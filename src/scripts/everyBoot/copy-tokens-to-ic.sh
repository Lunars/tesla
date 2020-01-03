#!/bin/bash

# Copies the tokens from CID to IC since you can always SSH to IC
function copyTokens() {
  scp /var/etc/saccess/tesla1 192.168.90.101:/home/tesla/tesla1
  scp /var/etc/saccess/tesla2 192.168.90.101:/home/tesla/tesla2
}

copyTokens

while inotifywait -e modify /var/etc/saccess/tesla1; do
  copyTokens
done
