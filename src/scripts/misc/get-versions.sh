#!/bin/bash

# Retrieve the firmware versions installed, and determine which partition they are on

OFFLINEMOUNTPOINT="/offline-usr"

ONLINEPART=$(cat /proc/self/mounts | grep "/usr" | grep ^/dev/mmcblk0p[12] | cut -b14)

if [ "$ONLINEPART" == "1" ]; then
  OFFLINEPART=2
elif [ "$ONLINEPART" == "2" ]; then
  OFFLINEPART=1
else
  echo "Error figuring out which partition is which."
  exit 0
fi

mkdir $OFFLINEMOUNTPOINT 2>/dev/null

mount -o ro /dev/mmcblk0p$OFFLINEPART $OFFLINEMOUNTPOINT

if [ ! -e "$OFFLINEMOUNTPOINT/deploy/platform.ver" ]; then
  echo "Error mounting offline partition."
  umount $OFFLINEMOUNTPOINT 2>/dev/null
  exit 0
fi

NEWVER=$(cat "$OFFLINEMOUNTPOINT/tesla/UI/bin/version.txt" | cut -d= -f2 | cut -d\- -f1)
NEWCUSTVER=$(cat "$OFFLINEMOUNTPOINT/tesla/UI/bin/customerVersion.txt" | cut -d= -f2 | cut -d\- -f1)
OLDVER=$(cat /usr/tesla/UI/bin/version.txt | cut -d= -f2 | cut -d\- -f1)

echo "Online version:  $OLDVER (/usr) /dev/mmcblk0p$ONLINEPART"
echo "Offline version: $NEWVER ($OFFLINEMOUNTPOINT) /dev/mmcblk0p$OFFLINEPART"
echo "Offline customer version: $NEWCUSTVER"
echo

umount $OFFLINEMOUNTPOINT
rmdir $OFFLINEMOUNTPOINT

exit
