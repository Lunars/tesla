#!/bin/bash

# Run this script in the background, because it may take a while to complete
# Usage: bash save-update.sh MODE &

PORT=$(cut -c 14-17 </var/etc/vin)
SERVER="tesla@yourserver.com"

# Non standard sshd ports can be set like so
#server="tesla@yourserver.com -p ${port}"

die() {
    echo "ERROR: $1" >&2
    exit 1
}

######### START NAVIGON
# @TODO: Add navigon image to arguments

NAVPART=$(cat /proc/mounts | grep opt/nav | head -n1 | cut -d " " -f1)
NAVMOUNT=$(cat /proc/mounts | grep opt/nav | head -n1 | awk '{print $2;}')
NAVSIZE=$(echo "$STATUS" | grep 'Online map package size:' | awk -F'Online map package size: ' '{print $2}' | awk '{print $1/64}')
NAVVERSION=$(cat $NAVMOUNT/VERSION | head -n1 | cut -d " " -f1)
echo "Version $NAVVERSION is mounted at $NAVPART $NAVMOUNT ($NAVSIZE)"
# dd if=$NAVPART bs=64 count=$NAVSIZE of=/disk/usb.*/$NAVVERSION.image
# SERVER=spam@xyz.com
# rsync -r -v --progress --partial --append-verify $NAVMOUNT/. $SERVER:~/$NAVVERSION/.
######### END NAVIGON

[[ $# != 1 ]] && die "Mode must be the only argument"
MODE="$1"

STATUS=$(curl http://cid:20564/status)
NEWSIZE=$(echo "$STATUS" | grep 'Offline dot-model-s size:' | awk -F'size: ' '{print $2}' | awk '{print $1/64}')
NEWVER=$(echo "$STATUS" | awk -F'built for package version: ' '{print $2}' | sed 's/\s.*$//')

# Ty kalud for finding offline part number
ONLINEPART=$(cat /proc/self/mounts | grep "/usr" | grep ^/dev/mmcblk0p[12] | cut -b14)
if [ "$ONLINEPART" == "1" ]; then
    OFFLINEPART=2
elif [ "$ONLINEPART" == "2" ]; then
    OFFLINEPART=1
else
    echo "Error figuring out which partition is which."
    exit 0
fi

if [ "$MODE" = cid ]; then
    echo "Saving to /tmp/$NEWVER.image"
    dd if=/dev/mmcblk0p$OFFLINEPART bs=64 of=/tmp/$NEWVER.image count=$NEWSIZE
elif [ "$MODE" = usb ]; then
    sudo mount -o rw,noexec,nodev,noatime,utf8 /dev/sda1 /disk/usb.*/
    dd if=/dev/mmcblk0p$OFFLINEPART bs=64 of=/disk/usb.*/$NEWVER.image count=$NEWSIZE
    sync
    umount /disk/usb.*/
elif [ "$MODE" = ssh ]; then
    echo "Saving to /tmp/$NEWVER.image on remote server"
    dd if=/dev/mmcblk0p$OFFLINEPART bs=64 count=$NEWSIZE | ssh $SERVER "dd of=/tmp/$NEWVER.image"
else
    die "MODE must be one of usb | cid | ssh"
fi

exit
