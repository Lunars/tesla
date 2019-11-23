#!/bin/bash

# Pull in global vars
eval "$(curl -s "https://raw.githubusercontent.com/Lunars/tesla/master/src/config.sh")"
mydir="${0%/*}"
[ -f "$mydir/config.sh" ] && source "$mydir/config.sh"

search="$homeOfLunars"
[ -n "$1" ] && homeOfLunars="$1"

echo "Installing Lunars to $homeOfLunars"

# Detect if we are running chrooted by checking if the root of the init process is the same as the root of this process
if [[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]]; then
    echo "[FAIL] Not running chrooted"
    exit 2
fi

echo "[OK] Not running chrooted"

rebootScript="on-reboot.sh"
onRebootFile="$homeOfLunars/scripts/$rebootScript"
startScript="/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/lunars-main.pid --exec /bin/bash $onRebootFile"

function downloadLunars() {
    echo "Downloading lunars source from Github..."

    mkdir -p "$homeOfLunars"
    curl -s -L https://github.com/Lunars/tesla/tarball/master | tar --wildcards -zx -C "$homeOfLunars" "Lunars-tesla-*/src"
    mv "$homeOfLunars"/*/src/* "$homeOfLunars"
    rm -rf "$homeOfLunars"/Lunars-tesla-*

    echo "[OK] Lunars source downloaded"

    if [[ -f /tmp/config.sh ]]; then
        # Restore config from tmp
        cp /tmp/config.sh "$homeOfLunars"/config.sh
        cp /tmp/tesla.ovpn "$homeOfLunars"/tesla.ovpn
        rm /tmp/config.sh /tmp/tesla.ovpn
        echo "[OK] Lunars config.sh and tesla.ovpn restored"
    fi
}

if [[ -f "$onRebootFile" ]]; then
    # Save config to tmp
    cp "$homeOfLunars"/config.sh /tmp/config.sh
    cp "$homeOfLunars"/tesla.ovpn /tmp/tesla.ovpn
    echo "[OK] Lunars config.sh and tesla.ovpn saved"

    rm -rf "$homeOfLunars"
    downloadLunars
else
    downloadLunars

    # In case a custom install path was given, replace it in config.sh too
    [ -n "$search" ] && sed -i "s~$search~$homeOfLunars~g" "$homeOfLunars/config.sh"
fi

# Installing crontab
alreadyInstalled=$(crontab -l | grep "$rebootScript")
if [[ "$alreadyInstalled" != "" ]]; then
    echo "[SKIP] Lunars cron already installed"
else
    # Just in case this file already exists
    rm /tmp/crontab 2>/dev/null
    crontab -l >/tmp/crontab
    echo "@reboot $startScript" >>/tmp/crontab
    crontab </tmp/crontab || exit 6
    rm /tmp/crontab
    echo "[OK] Lunars cron installed"
fi

# Check if already running
rebootProcess=$(pgrep -f "$rebootScript")
if [ -n "$rebootProcess" ]; then
    echo "[SKIP] Lunars $rebootScript is already running"
else
    $startScript
    echo "[OK] Lunars $rebootScript backgrounded"
fi

echo "[DONE] Lunars is now installed, have fun!"
