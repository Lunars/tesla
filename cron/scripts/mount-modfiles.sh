#!/bin/bash -x

# Usage: Save path to /var/added/modfiles/-root-/-dir-/-to-/-file-/file.png
# eg: /var/added/modfiles/usr/bin/seceth

#if an argument is provided multiple directories are allowed

#first umount

for bindmount in $(mount | grep bind | awk '{ print $1 }')
do
 /bin/umount $bindmount
done

cd /var/added/modfiles$1
for modfile in $(find . -type f)
do
 #in case the containing dir isn't there yet
 mkdir -p /$(dirname $modfile) 2> /dev/null
 #displays warnings because mounting a file
 /bin/mount --bind $modfile /$modfile 2> /dev/null
 /bin/mount -o remount,ro /$modfile 2> /dev/null
done

#if theres a changed init script, reload upstart
if [ -d /var/added/modfiles$1/etc/init/ ]
then
 /usr/cid-slash-sbin/initctl reload-configuration
fi
