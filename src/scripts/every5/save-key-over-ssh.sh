#!/bin/bash

# Saves keys over an ssh connection by writing them to a text file on the remote
# server. Does not require any web server be running on the server, only sshd.
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

TIME=$(date "+%Y-%m-%d %k:%M:%S")
VIN=$(</var/etc/vin)
KEY1=$(</var/etc/saccess/tesla1)
KEY2=$(</var/etc/saccess/tesla2)

REMOTE_SSH_PORT=22
REMOTE_SSH_USER=user
REMOTE_SSH_LOCAL_KEYFILE=/home/user_on_tesla_cid/.ssh/id_rsa
REMOTE_SSH_FQDN=your.domain.or.ip
REMOTE_KEYS_FILE=tesla-keys.txt

if [ "$REMOTE_SSH_FQDN" == "your.domain.or.ip" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

ssh -T -i $REMOTE_SSH_LOCAL_KEYFILE -o StrictHostKeyChecking=no -p $REMOTE_SSH_PORT $REMOTE_SSH_USER@$REMOTE_SSH_FQDN "echo 'Time: $TIME | VIN: $VIN | Key 1: $KEY1 | Key 2: $KEY2' >> $REMOTE_KEYS_FILE"
