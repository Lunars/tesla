#!/bin/bash

# Prevent the car from grabbing new fw updates
# Switch to true to block firmware
ENABLE=false

if [ "$ENABLE" == "false" ]; then
    echo "Script not yet setup, quitting"
    exit 1
fi

if grep --quiet firmware.vn.teslamotors.com /etc/hosts; then
  echo "Block in Place"
else
  echo "Adding block"
  echo "0.0.0.0 firmware.vn.teslamotors.com"  >> /etc/hosts
fi
