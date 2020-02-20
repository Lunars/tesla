#!/bin/sh

if [[ "$urlToVitalsPHP" =~ "yourserver.com" ]]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

localVitals="http://cid:4035/vitals?raw=true"
vitalsPath="/usr/tesla/UI/assets/web_content/vitals"
allowedURL="$urlToVitalsPHP?vin=$(</var/etc/vin)" # Append vin

currentMd5=$(curl -s "$localVitals" | curl -s "$allowedURL" -d @- --header "Content-Type: application/json")

function updateVitals() {
  md5=$(md5sum $vitalsPath/assets/vehicle_vitals_layout.js | awk '{ print $1 }')

  if [ "$md5" == "$1" ]; then
    echo "Server has latest vitals"
    return
  fi

  echo "Updating vitals on server $1 != $md5"
  tar -C $vitalsPath/ -czf - . | curl -s "$allowedURL&updateVitals" --data-binary @-
}

updateVitals $currentMd5
