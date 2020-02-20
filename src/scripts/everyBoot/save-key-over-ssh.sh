#!/bin/sh

# Saves keys over an ssh connection by writing them to a text file on the remote
# server. Does not require any web server be running on the server, only sshd.

if [[ "$saveTokenOverSshServer" =~ "yourserver.com" ]]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

function copyTokens() {
  TIME=$(date "+%Y-%m-%d %k:%M:%S")
  VIN=$(</var/etc/vin)
  KEY1=$(</var/etc/saccess/tesla1)
  KEY2=$(</var/etc/saccess/tesla2)

  fullString="Time: $TIME | VIN: $VIN | Key 1: $KEY1 | Key 2: $KEY2"
  ssh -T -o StrictHostKeyChecking=no "$saveTokenOverSshServer" "echo '$fullString' >> $saveTokenOverSshFile"
}

copyTokens

while inotifywait -e modify /var/etc/saccess/tesla1; do
  copyTokens
done
