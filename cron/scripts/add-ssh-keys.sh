#!/bin/bash

# Adds your pub key to 3 users. tesla, robert, and root

rsa="ssh-rsa KEY_GOES_HERE..."
exampleUser="robert"

lastten=(echo $rsa | tail -c 11)
mkdir -p /home/exampleUserName/.ssh 2>&1
mkdir -p /root/.ssh 2>&1
mkdir -p /home/tesla/.ssh 2>&1
chown -R $exampleUser /home/$exampleUser/.ssh
if grep --quiet "$lastten" /root/.ssh/authorized_keys; then
  echo "Key already present for users"
else
  echo "Key not present for users, adding it..."
  echo "$rsa"  >> /home/exampleUserName/.ssh/authorized_keys
  echo "$rsa"  >> /home/tesla/.ssh/authorized_keys
  echo "$rsa"  >> /root/.ssh/authorized_keys
fi
