#!/bin/bash

tinkla_server="https://tinkla.us/vitals/upload.php"

# Username and password are case sensitive
tinkla_usr=""
tinkla_pswd=""

if [ "$tinkla_usr" == "" ]; then
    echo "Script not yet setup, quitting"
    exit 1
fi

echo "{\"username\":\"$tinkla_usr\",\"password\":\"$tinkla_pswd\",\"vitals\":" >vitals.json
curl -s "http://cid:4035/vitals?raw=true" >>vitals.json
echo "}" >>vitals.json
curl -X POST "$tinkla_server" -d @vitals.json -H "Accept: application/json" -H "Content-Type: application/json"
rm vitals.json
