#!/bin/bash

ENABLE=true

if [ "$ENABLE" == "false" ]; then
    echo "Script not enabled, quitting"
    exit 1
fi

if [ ! -f /etc/tegraline-release ]
then
  touch /etc/tegraline-release
fi

if [ ! -f /var/etc/disable-seceth ]
then
  touch /var/etc/disable-seceth
fi
