ENABLE=false

if [ "$ENABLE" == "false" ]; then
  echo "Script not enabled, quitting"
  exit 1
fi

# Credits to https://github.com/jnuyens/freedomev/blob/master/freedomevstart
# This starts freedomev in case you have a USB that contains it

# bootstrap version 2019070301
# datestring needs to be at this position to verify if its the last version
#
# This script should be placed in /var/ and launched every minute out of cron
#
# checks for presence of freedomev USB stick and performs its magic
# if stick is not present - kills thing launched and does nothing -
# this way its easy to 
# disable the entire freedomev system and not overload Car Service 
# with strange requests. If you run into problems, reset the central
# display and instrument cluster with the buttons on the steering wheel
# and remove the freedomev USB stick
#
#Copyright 2018, Jasper Nuyens <jnuyens@linuxbe.com>
#Licensed under the GNU Affero GPL license as published on https://www.gnu.org/licenses/agpl-3.0.html

#check if freedomev was already detected
if [[ -f /tmp/freedomevmountpoint ]]
then
 freedomevstarted=true
 usbmountpoint=$(cat /tmp/freedomevmountpoint)
else
 freedomevstarted=false
fi

#possibly check if there are no double mounts or dangling mountpoints

#function to kill remaining freedomev chrooted processes and umount
function killandumount {
 #run all deactivation scripts
 for deactivationscript in /tmp/freedomev/*
 do
  bash ${deactivationscript} && rm ${deactivationscript}
 done
 #umount filesystems
 umount ${usbmountpoint}/proc/
 umount ${usbmountpoint}/sys
 umount ${usbmountpoint}/dev
 umount ${usbmountpoint}/tmp
 umount ${usbmountpoint}/dev/pts
 umount -f ${usbmountpoint}
 rm /tmp/freedomevmountpoint
 #check if no mount points are dangling
 curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message="FreedomEV Disabled."
}

#check if the USB stick is present
usbstickpresent=$(cat /proc/partitions | grep sd[a-z]1$)
if [[ ${usbstickpresent} == "" ]]
then 
 if ! ${freedomevstarted}
 then
  #we want to end as quickly as possible if we don't need to do anything 
  #possibly we need to check if we need to kill some processes or umount bind mounted stuff
  #for now, one can also reboot after removing the stick
  exit 0
 else 
  #we need to kill all possible processes who run on the removed rootfs from the USB stick and possibly umount
  killandumount 
 fi
fi

#determine mountpoint - should not be emty
usbmountpoint=$(mount | grep '^/dev/sd' | awk '{ print $3 }' | head -n 1)
if [[ ${usbmountpoint} == "" ]]
then
 exit 3
else
 echo ${usbmountpoint} > /tmp/freedomevmountpoint
fi

#check if it's mounted read-only, possibly remount - otherwise exit, maybe still busy mounting, will try again next run
usbstickmounted=$(mount |grep '^/dev/sd.1.*(ro,noexec,nodev,noatime)$')
if [[ ${usbstickmounted} != "" ]]
then
 mount -o remount,rw,exec,dev /dev/sd?1 || exit 2
fi
 
#check if it contains the correct content and determine the version
freedomevversion=$(cat ${usbmountpoint}/etc/freedomevversion)
if [[ ${freedomevversion} == "" ]]
then
 echo no ${usbmountpoint}/etc/freedomevversion
 if ${freedomevstarted}
 then
  killandumount
 fi
 exit 4
fi
echo freedomevstarted=${freedomevstarted}


function checkbootstrapversion {
 #checks the first line of this file and possibly updates it
 # bootstrap version 2019012701
 runningversion=$(head -n 1 /var/freedomevstart | awk '{ print $4 }')
 usbversion=$(head -n 1 ${usbmountpoint}/freedomevstart | awk '{ print $4 }')
 if [[ "$runningversion" != "$usbversion" ]]
 then
  cp ${usbmountpoint}/freedomevstart /var/freedomevstart 
  sync
  curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message="FreedomEV core bootstrap updated!"
  curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message="Please remove the US stick then "
  curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message=" wait for FreedomEV to disable and reinsert"
 fi
}

#initial start
if ! ${freedomevstarted}
then
 echo ${usbmountpoint} > /tmp/freedomevmountpoint
 mount -t proc archproc ${usbmountpoint}/proc/
 mount -t sysfs archsys ${usbmountpoint}/sys
 mount -o bind /dev ${usbmountpoint}/dev
 mount -o bind /tmp ${usbmountpoint}/tmp
 mount -t devpts archdevpts ${usbmountpoint}/dev/pts
 #I prefer not to put the key in the public git so we cp it to /tmp
 mkdir  /tmp/freedomev/ 2> /dev/null
 cp /root/.ssh/id_dsa /tmp/freedomev/id_dsa
 #some more hacking powers
 mount /var -o remount,exec
 mount -o remount,exec /opt/navigoff
 checkversion
 # Disable message for silent start
 #curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message="FreedomEV Activated! Version: ${freedomevversion}"
 export usbmountpoint
 /bin/bash ${usbmountpoint}/freedomev/tools/activation-outside-chroot-jail
 /usr/sbin/chroot ${usbmountpoint} /bin/bash /freedomev/tools/activation
 checkbootstrapversion
fi

#launch the checks for freedomev core such as periodic check for version and periodic checks for certain apps
export usbmountpoint freedomevversion
/usr/sbin/chroot ${usbmountpoint} /bin/bash /freedomev/tools/runperiodic
