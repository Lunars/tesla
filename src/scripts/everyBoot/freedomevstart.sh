# Credits to https://github.com/jnuyens/freedomev/blob/master/freedomevstart
# This starts freedomev in case you have a USB that contains it

# checks for presence of freedomev USB stick and performs its magic
# if stick is not present - kills thing launched and does nothing -
# this way its easy to
# disable the entire freedomev system and not overload Car Service
# with strange requests.
#
#Copyright 2018, Jasper Nuyens <jnuyens@linuxbe.com>
#Licensed under the GNU Affero GPL license as published on https://www.gnu.org/licenses/agpl-3.0.html

#check if freedomev was already detected
if [[ -f /tmp/freedomevmountpoint ]]; then
  freedomevstarted=true
  usbmountpoint=$(cat /tmp/freedomevmountpoint)
else
  freedomevstarted=false
fi

#possibly check if there are no double mounts or dangling mountpoints

#function to kill remaining freedomev chrooted processes and umount
function killandumount() {
  #run all deactivation scripts
  for deactivationscript in /tmp/freedomev/*; do
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
}

#check if the USB stick is present
usbstickpresent=$(cat /proc/partitions | grep sd[a-z]1$)
if [[ ${usbstickpresent} == "" ]]; then
  if ! ${freedomevstarted}; then
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
if [[ ${usbmountpoint} == "" ]]; then
  exit 3
else
  echo ${usbmountpoint} >/tmp/freedomevmountpoint
fi

#check if it's mounted read-only, possibly remount - otherwise exit, maybe still busy mounting, will try again next run
usbstickmounted=$(mount | grep '^/dev/sd.1.*(ro,noexec,nodev,noatime)$')
if [[ ${usbstickmounted} != "" ]]; then
  mount -o remount,rw,exec,dev /dev/sd?1 || exit 2
fi

#check if it contains the correct content and determine the version
freedomevversion=$(cat ${usbmountpoint}/etc/freedomevversion)
if [[ ${freedomevversion} == "" ]]; then
  echo no ${usbmountpoint}/etc/freedomevversion
  if ${freedomevstarted}; then
    killandumount
  fi
  exit 4
fi
echo freedomevstarted=${freedomevstarted}

#initial start
if ! ${freedomevstarted}; then
  echo ${usbmountpoint} >/tmp/freedomevmountpoint
  mount -t proc archproc ${usbmountpoint}/proc/
  mount -t sysfs archsys ${usbmountpoint}/sys
  mount -o bind /dev ${usbmountpoint}/dev
  mount -o bind /tmp ${usbmountpoint}/tmp
  mount -t devpts archdevpts ${usbmountpoint}/dev/pts
  #I prefer not to put the key in the public git so we cp it to /tmp
  mkdir /tmp/freedomev/ 2>/dev/null
  cp /root/.ssh/id_dsa /tmp/freedomev/id_dsa
  #some more hacking powers
  mount /var -o remount,exec
  mount -o remount,exec /opt/navigoff
  export usbmountpoint
  /bin/bash ${usbmountpoint}/freedomev/tools/activation-outside-chroot-jail
  /usr/sbin/chroot ${usbmountpoint} /bin/bash /freedomev/tools/activation
fi

#launch the checks for freedomev core such as periodic check for version and periodic checks for certain apps
export usbmountpoint freedomevversion
/usr/sbin/chroot ${usbmountpoint} /bin/bash /freedomev/tools/runperiodic
