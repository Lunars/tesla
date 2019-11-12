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

rebootScript="on-reboot.sh"
onRebootFile="$homeOfLunars/scripts/$rebootScript"

if [[ -f "$onRebootFile" ]]; then
    echo [SKIP] Lunars source already downloaded
else
    # Downloading repo to CID
    mkdir -p $homeOfLunars
    curl -sL https://github.com/Lunars/tesla/tarball/master | tar --wildcards -zx -C $homeOfLunars "Lunars-tesla-*/src"
    mv $homeOfLunars/*/src/* $homeOfLunars
    rm -rf $homeOfLunars/Lunars-tesla-*

    [ ! -z "$search" ] && sed -i "s~$search~$homeOfLunars~g" "$homeOfLunars/config.sh"
    echo [OK] Lunars source downloaded
fi

# Installing crontab
alreadyInstalled=$(crontab -l | grep "$rebootScript")
if [[ "$alreadyInstalled" != "" ]]; then
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

# Check if already running
rebootProcess=$(ps ax | grep "$rebootScript" | grep -v $$ | grep bash | grep -v grep)
if [ ! -z "$rebootProcess" ]; then
    echo "[SKIP] Lunars $rebootScript is already running"
else
    /bin/bash $onRebootFile >/dev/null 2>&1 &
    echo [OK] Lunars $rebootScript backgrounded
fi

echo [DONE] Lunars is now installed, have fun!
