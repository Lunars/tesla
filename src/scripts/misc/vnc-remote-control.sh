#!/bin/bash

# This lets you control your MCU remotely from your computer
# Clicking inside the VNC client routes the click to your MCU

# Downloads a 2.3mb rootfs and chroots to it to install x11vnc
# I use reverse shell to forward port 5900, then connect localhost:5900

# eg https://i.imgur.com/WRb8MFv.png

# Don't run me inside chroot
[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ] && exit

CHROOT="/home/tesla/alpine3.11"

function mountStuff() {
    mount -o remount,exec,suid,symfollow /home # need this to allow execution on /home
    mount -o bind /dev ${CHROOT}/dev
    mount -o bind /proc ${CHROOT}/proc
    mount -t sysfs archsys ${CHROOT}/sys
    mount -o bind /tmp ${CHROOT}/tmp
    mount -t devpts archdevpts ${CHROOT}/dev/pts
    mount /var -o remount,exec,suid,symfollow
    mount -o bind /var ${CHROOT}/var
}

if [ ! -d "$CHROOT" ]; then
    ARCH=$(uname -m)
    ALPINE_URI="http://dl-cdn.alpinelinux.org/alpine/v3.11/releases/$ARCH/alpine-minirootfs-3.11.3-$ARCH.tar.gz"
    curl -O ${ALPINE_URI}
    mkdir -p ${CHROOT}
    tar -zxvf $(basename ${ALPINE_URI}) -C ${CHROOT}
    mountStuff
    cat <<EOF | chroot ${CHROOT} /bin/sh
        rm -rf /var/cache/apk
        mkdir -p /var/cache/apk
        apk update
        apk add x11vnc xauth bash curl jq
EOF
else
    mountStuff
fi

VERTICAL_DISPLAY=true
ROTATION=90
if [[ "$(< /var/etc/chassistype)" == "Model3" ]]; then
    VERTICAL_DISPLAY=false
    ROTATION=0
fi

if [ ! -f "/var/captureClicks.sh" ]; then
    cat > /var/captureClicks.sh << 'EOF'
#!/bin/bash
EOF << "VERTICAL_DISPLAY=${VERTICAL_DISPLAY}" << 'EOF'

while read line; do
    if [[ "$line" == *ButtonPress* ]]; then
        y=$(echo $line | cut -d " " -f 3)
        x=$(echo $line | cut -d " " -f 4)

        if [ "$VERTICAL_DISPLAY" == true ]; then
            x=$((1200 - $x))
        fi

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
    DISPLAY=:0 x11vnc -noipv6 -display :0 -nopw -rotate ${ROTATION} -rfbport 5900 -nodragging -pipeinput "/var/captureClicks.sh"
EOF
