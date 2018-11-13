#!/bin/bash

mkdir -p /home/tesla/.ssh 2>&1
if grep --quiet PARTIAL_KEY_GOES_HERE /home/tesla/.ssh/authorized_keys; then
  echo "Key already present for tesla user"
else
  echo "Key not present for tesla user, adding it..."
  echo "ssh-rsa KEY_GOES_HERE"  >> /home/tesla/.ssh/authorized_keys
fi
