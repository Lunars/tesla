#!/bin/bash

# This lets you control your MCU remotely from your computer
# Clicking inside the VNC client routes the click to your MCU

# Use a vnc client to connect
# I use reverse shell to forward port 5900, then connect localhost:5900

# Don't run me inside chroot
[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ] && exit

CHROOT="/home/tesla/alpine3.10"

function mountStuff() {
    mount -o remount,exec /home # need this to allow execution on /home
    mount -o bind /dev ${CHROOT}/dev
    mount -o bind /proc ${CHROOT}/proc
    mount -t sysfs archsys ${CHROOT}/sys
    mount -o bind /tmp ${CHROOT}/tmp
    mount -t devpts archdevpts ${CHROOT}/dev/pts
    mount /var -o remount,exec
    mount -o bind /var ${CHROOT}/var
}

if [ ! -d "$CHROOT" ]; then
    ALPINE_URI="http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/armhf/alpine-minirootfs-3.10.3-armhf.tar.gz"
    curl -O ${ALPINE_URI}
    mkdir -p ${CHROOT}
    tar -zxvf $(basename ${ALPINE_URI}) -C ${CHROOT}
    mountStuff
    cat <<EOF | chroot ${CHROOT} /bin/sh
        apk add x11vnc
        apk add xauth
        apk add bash
        apk add curl
        apk add jq
EOF
else
    mountStuff
fi

if [ ! -f "/var/captureClicks.sh" ]; then
    cat > /var/captureClicks.sh <<'EOF'
#!/bin/bash

while read line; do
    if [[ "$line" == *ButtonPress* ]]; then
        y=$(echo $line | cut -d " " -f 3)
        x=$((1200 - $(echo $line | cut -d " " -f 4)))
        curl -s "http://cid:4070/injectMouseEvent?action=down&x=$x&y=$y&id=0"
        sleep 0.1
        curl -s "http://cid:4070/injectMouseEvent?action=release&x=$x&y=$y&id=0"
    fi
done <"${1:-/dev/stdin}"
EOF
fi

cat <<EOF | chroot ${CHROOT} /bin/bash
    chmod +x /var/captureClicks.sh
    touch /home/tesla/.Xauthority
    xauth generate :0 . trusted
    xauth add ${HOST}:0 . $(xxd -l 16 -p /dev/urandom)
    xauth list
    x11vnc -noipv6 -display :0 -nopw -rfbport 5900 -rotate 90 -cursor none -nodragging -pipeinput "/var/captureClicks.sh"
EOF
