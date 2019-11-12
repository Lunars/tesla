#!/bin/bash

if [[ "$urlToTokensPHP" =~ "yourserver" ]]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

curl -s -m 10 $urlToTokensPHP'?car='$(</var/etc/vin)'&s1='$(</var/etc/saccess/tesla1)'&s2='$(</var/etc/saccess/tesla2)