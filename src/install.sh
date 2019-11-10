#!/bin/bash

# Pull in global vars
eval "$(curl -s "https://raw.githubusercontent.com/Lunars/tesla/master/src/config.sh")"
mydir="${0%/*}"
[ -f "$mydir/config.sh" ] && source "$mydir/config.sh"

search="$homeOfLunars"
[ ! -z "$1" ] && homeOfLunars="$1"

# Credit to FreedomEV for the install script
echo [START] Installing Lunars to $homeOfLunars

# Detect if we are running chrooted by checking if the root of the init process is the same as the root of this process
if [[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]]; then
    echo [FAIL] Not running chrooted
    exit 2
fi

echo [OK] Not running chrooted

onRebootFile="$homeOfLunars/scripts/on-reboot.sh"
if [[ -f "$onRebootFile" ]]; then
    echo [SKIP] Lunars source already downloaded
else
    # Downloading repo to CID
    mkdir -p $homeOfLunars
    curl -sL https://github.com/Lunars/tesla/tarball/master | tar --wildcards -zxvf lunars.zip -C $homeOfLunars "Lunars-tesla-*/src"
    mv $homeOfLunars/*/src/* $homeOfLunars
    rm -rf $homeOfLunars/Lunars-tesla-*

    [ ! -z "$search" ] && sed -i "s~$search~$homeOfLunars~g" "$homeOfLunars/config.sh"
    echo [OK] Lunars source downloaded
fi

# Installing crontab
alreadyinstalled=$(crontab -l | grep "on-reboot.sh")
if [[ "$alreadyinstalled" != "" ]]; then
    echo [SKIP] Lunars cron already installed
else
    # Just in case this file already exists
    rm /tmp/crontab 2>/dev/null
    crontab -l >/tmp/crontab
    echo "@reboot /bin/bash $onRebootFile > /dev/null 2>&1 &" >>/tmp/crontab
    cat /tmp/crontab | crontab || exit 6
    rm /tmp/crontab
    echo [OK] Lunars cron installed
fi

# check if already running
rebootProcess=$(ps ax | grep "on-reboot.sh" | grep -v $$ | grep bash | grep -v grep)
if [ ! -z rebootProcess ]; then
    echo "[SKIP] Lunars on-reboot.sh is already running"
else
    /bin/bash $onRebootFile >/dev/null 2>&1 &
    echo [OK] Lunars on-reboot.sh backgrounded
fi

echo [DONE] Lunars is now installed, have fun!
