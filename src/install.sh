#!/bin/bash

# Usage:
# install.sh <customPathToHome | "cron">

if [ "$EUID" -ne 0 ]; then
  echo "[FAIL] Script must be ran as root"
  exit
else
  echo "[OK] Installing Lunars as root"
fi

# Pull in global vars
[ "$1" != "cron" ] && eval "$(curl -s "https://raw.githubusercontent.com/Lunars/tesla/master/src/config.sh")"

# Set default home if we're running a cron flag
[ "$1" == "cron" ] && homeOfLunars="/var/lunars"

# The default home provided by Github config.sh
search="$homeOfLunars"

# The overridden home provided by first argument
[ -n "$1" ] && [ "$1" != "cron" ] && homeOfLunars="$1"

# Pull in your custom vars if you already have Lunars installed
[ -f "$homeOfLunars/config.sh" ] && source "$homeOfLunars/config.sh"

echo "Installing Lunars to $homeOfLunars"

# Detect if we are running chrooted by checking if the root of the init process is the same as the root of this process
if [[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]]; then
  echo "[FAIL] Not running when chrooted"
  exit 2
fi

echo "[OK] Not running chrooted"

rebootScript="on-reboot.sh"
onRebootFile="$homeOfLunars/scripts/$rebootScript"
startScript="/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/lunars-main.pid --exec /bin/bash $onRebootFile"

function checkConfigScripts() {
  cd "$homeOfLunars/$1" || exit
  for f in *.sh; do
    if grep -q "$1/$f" "$homeOfLunars/config.sh"; then
      echo "[SKIP] $f already exists in config.sh"
    else
      echo "[OK] Added $f to config.sh and left disabled (must manually enable)"
      sed -i "/$2=/a #    \"\$homeOfLunars/$1/$f\"" "$homeOfLunars/config.sh"
    fi
  done
}

function downloadLunars() {
  echo "Downloading lunars source from Github..."

  mkdir -p "$homeOfLunars"
  curl -s -L https://github.com/Lunars/tesla/tarball/master | tar --wildcards -zx -C "$homeOfLunars" "Lunars-tesla-*/src"
  mv "$homeOfLunars"/*/src/* "$homeOfLunars"
  rm -rf "$homeOfLunars"/Lunars-tesla-*

  echo "[OK] Lunars source downloaded"

  if [[ -f /tmp/config.sh ]]; then
    # Restore config from tmp
    mv /tmp/overwrite-files "$homeOfLunars"
    mv /tmp/config.sh "$homeOfLunars"
    mv /tmp/tesla.ovpn "$homeOfLunars"
    echo "[OK] Lunars config.sh, tesla.ovpn, and overwrite-files restored"

    echo "Checking for new scripts that are missing in config.sh..."
    checkConfigScripts scripts/everyBoot scheduledScripts
    checkConfigScripts scripts/everyFiveMinutes everyFiveMinuteScripts
  fi
}

# When calling with "cron" argument, don't redownload. Just do CRON stuff
if [ -z "$1" ] || [ -n "$1" ] && [ "$1" != "cron" ]; then
  if [[ -f "$onRebootFile" ]]; then
    # Save config to tmp
    rm -rf /tmp/overwrite-files /tmp/config.sh /tmp/tesla.ovpn
    mv "$homeOfLunars"/overwrite-files /tmp
    mv "$homeOfLunars"/config.sh /tmp
    mv "$homeOfLunars"/tesla.ovpn /tmp
    echo "[OK] Lunars config.sh, tesla.ovpn, and overwrite-files saved"

    rm -rf "$homeOfLunars"
    downloadLunars
  else
    downloadLunars

    # In case a custom install path was given, replace it in config.sh too
    [ -n "$search" ] && sed -i "s~$search~$homeOfLunars~g" "$homeOfLunars/config.sh"
  fi
else
  echo "[SKIP] Lunars download due to cron flag"
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
