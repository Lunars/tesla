#!/bin/bash

# Copies the tokens from CID to IC since you can always SSH to IC 

ENABLE=false

if [ "$ENABLE" == "false" ]; then
    echo "Script not enabled, quitting"
    exit 1
fi

scp /var/etc/saccess/tesla1 192.168.90.101:/home/tesla/tesla1
scp /var/etc/saccess/tesla2 192.168.90.101:/home/tesla/tesla2
