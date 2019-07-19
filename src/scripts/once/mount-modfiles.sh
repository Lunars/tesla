#!/bin/bash -x

# Usage: Save path to ./overwrite-files/-root-/-dir-/-to-/-file-/file.png
# eg: ./overwrite-files/usr/bin/seceth

# if an argument is provided multiple directories are allowed

saveLocation="/var/root/lunars/src/overwrite-files"

ENABLE=true

if [ "$ENABLE" == "false" ]; then
  echo "Script not enabled, quitting"
  exit 1
fi

mkdir -p "$saveLocation/usr/local/bin/"
for bindmount in $(mount | grep -e bind -e lunars | awk '{ print $1 }'); do
  chmod +x $bindmount 2>/dev/null
  /bin/umount $bindmount
done

cd $saveLocation$1
for modfile in $(find . -type f); do
  #in case the containing dir isn't there yet
  mkdir -p /$(dirname $modfile) 2>/dev/null
  #displays warnings because mounting a file
  /bin/mount --bind $modfile /$modfile 2>/dev/null
  chmod +x $modfile 2>/dev/null
  /bin/mount -o remount,ro /$modfile 2>/dev/null
done

#if theres a changed init script, reload upstart
if [ -d $saveLocation$1/etc/init/ ]; then
  /usr/cid-slash-sbin/initctl reload-configuration
fi
