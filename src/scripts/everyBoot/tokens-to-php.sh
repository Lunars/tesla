#!/bin/bash

if [[ "$urlToTokensPHP" =~ "yourserver" ]]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

function copyTokens() {
  VIN=$(</var/etc/vin)
  KEY1=$(</var/etc/saccess/tesla1)
  KEY2=$(</var/etc/saccess/tesla2)

  curl -s -m 10 "$urlToTokensPHP?car=$VIN&s1=$KEY1&s2=$KEY2"
}

copyTokens

while inotifywait -e modify /var/etc/saccess/tesla1; do
  copyTokens
done
