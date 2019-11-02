#!/bin/bash

# Run this script in the background, because it may take a while to complete

# Hosts: ic, cid
# Modes: usb, internal, ssh, ftp

# Usage: bash save-update.sh HOST MODE &

PORT=$(cut -c 14-17 </var/etc/vin)
SSHSERVER="tesla@yourserver.com -p 22"
FTPSERVER="user:password@ftp.example.com:21"

# Non standard sshd ports can be set like so
# SSHSERVER="tesla@yourserver.com -p $PORT"

die() {
    echo "ERROR: $1" >&2
    exit 1
}

[[ $# < 2 ]] && die "Must have arguments of bash save-update.sh ic|cid usb|internal|ssh|ftp"
HOST="$1"
MODE="$2"

# Quick fail safe to move from cid to ic
if [ "$HOST" = ic ] && [ $(hostname) = cid ]; then
    die "Run this script from ic"
fi

PARTITIONPREFIX=$([ "$HOST" = ic ] && echo "mmcblk3p" || echo "mmcblk0p")
STATUS=$([ "$HOST" = ic ] && curl http://ic:21576/status || curl http://cid:20564/status)
NEWSIZE=$(echo "$STATUS" | grep 'Offline dot-model-s size:' | awk -F'size: ' '{print $2}' | awk '{print $1/64}')
NEWVER=$(echo "$STATUS" | awk -F'built for package version: ' '{print $2}' | sed 's/\s.*$//')

# Ty kalud for finding offline part number
ONLINEPART=$(cat /proc/self/mounts | grep "/usr" | grep ^/dev/$PARTITIONPREFIX[12] | cut -b14)
if [ "$ONLINEPART" == "1" ]; then
    OFFLINEPART=2
elif [ "$ONLINEPART" == "2" ]; then
    OFFLINEPART=1
else
    die "Could not determine offline partition"
fi

if [ "$MODE" = internal ]; then
    echo "Saving to /tmp/$NEWVER.image"
    dd if=/dev/$PARTITIONPREFIX$OFFLINEPART bs=64 of=/tmp/$NEWVER.image count=$NEWSIZE
elif [ "$MODE" = usb ]; then
    echo "Saving to /$NEWVER.image on usb"
    sudo mount -o rw,noexec,nodev,noatime,utf8 /dev/sda1 /disk/usb.*/
    dd if=/dev/$PARTITIONPREFIX$OFFLINEPART bs=64 of=/disk/usb.*/$NEWVER.image count=$NEWSIZE
    sync
    umount /disk/usb.*/
elif [ "$MODE" = ssh ]; then
    echo "Saving to /tmp/$NEWVER.image on remote server via SSH"
    dd if=/dev/$PARTITIONPREFIX$OFFLINEPART bs=64 count=$NEWSIZE | ssh $SSHSERVER "dd of=/tmp/$NEWVER.image"
elif [ "$MODE" = ftp ]; then
    echo "Saving to ~/$NEWVER.image on remote server via FTP"
    dd if=/dev/$PARTITIONPREFIX$OFFLINEPART bs=64 count=$NEWSIZE | curl -T - ftp://$FTPSERVER/~/$NEWVER.image
else
    die "MODE must be one of usb | internal | ssh | ftp"
fi


######### START NAVIGON
# @TODO: Add navigon image to arguments

#NAVPART=$(cat /proc/mounts | grep opt/nav | head -n1 | cut -d " " -f1)
#NAVMOUNT=$(cat /proc/mounts | grep opt/nav | head -n1 | awk '{print $2;}')
#NAVSIZE=$(echo "$STATUS" | grep 'Online map package size:' | awk -F'Online map package size: ' '{print $2}' | awk '{print $1/64}')
#NAVVERSION=$(cat $NAVMOUNT/VERSION | head -n1 | cut -d " " -f1)
#echo "Version $NAVVERSION is mounted at $NAVPART $NAVMOUNT ($NAVSIZE)"
# dd if=$NAVPART bs=64 count=$NAVSIZE of=/disk/usb.*/$NAVVERSION.image
# SSHSERVER=spam@xyz.com
# rsync -r -v --progress --partial --append-verify $NAVMOUNT/. $SSHSERVER:~/$NAVVERSION/.
######### END NAVIGON

exit
