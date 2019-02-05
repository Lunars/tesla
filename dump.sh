#!/usr/bin/env sh

# Returns two URLs for your car's config

curl -s "http://localhost:4035/get_data_values?format=csv&show_invalid=true" | socat - tcp:termbin.com:9999

access-internal-dat.pl --get ~/i.d
cat ~/i.d | socat - tcp:termbin.com:9999
