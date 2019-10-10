#!/bin/bash

# Credit to FreedomEV for the install script
echo [START] Install Lunars

# Detect if we are running chrooted by checking if the root of the init process is the same as the root of this process
if [[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]]; then
    echo [FAIL] Not running chrooted
    exit 2
fi

echo [OK] Not running chrooted

onRebootFile="/home/lunars/src/scripts/on-reboot.sh"
if [[ -f "$onRebootFile" ]]; then
    echo [SKIP] Lunars source already downloaded
else
    # Downloading repo to CID
    mkdir -p /home/lunars
    curl -sL https://github.com/Lunars/tesla/tarball/master -o ./lunars.zip || exit 5
    tar xf ./lunars.zip -C /home/lunars/
    rm ./lunars.zip

    # Only syncs over new files, does not overwrite newer files
    rsync -raz --update --remove-source-files /home/lunars/Lunars-tesla*/ /home/lunars/
    rm -rf /home/lunars/Lunars-tesla*
    echo [OK] Lunars source downloaded
fi

# Installing crontab
alreadyinstalled=$(crontab -l | grep /home/lunars)
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
if ps ax | grep $onRebootFile | grep -v $$ | grep bash | grep -v grep; then
    echo "[SKIP] Lunars on-reboot.sh is already running"
else
    /bin/bash $onRebootFile >/dev/null 2>&1 &
    echo [OK] Lunars on-reboot.sh backgrounded
fi

echo [DONE] Lunars is now installed, have fun!
