#!/bin/bash

mkdir -p /home/exampleUserName/.ssh 2>&1
chown -R exampleUserName /home/exampleUserName/.ssh
if grep --quiet exampleUserName /home/exampleUserName/.ssh/authorized_keys; then
  echo "Key already present for exampleUserName user"
else
  echo "Key not present for exampleUserName user, adding it..."
  echo "ssh-rsa KEY_GOES_HERE"  >> /home/exampleUserName/.ssh/authorized_keys
fi
