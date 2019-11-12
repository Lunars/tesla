#!/bin/bash

if [[ "$urlToVitalsPHP" =~ "yourserver.com" ]]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

localVitals="http://cid:4035/vitals?raw=true"
curl -s "$localVitals" | curl -X POST "$urlToVitalsPHP" -d @- --header "Content-Type: application/json"