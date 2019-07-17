#!/bin/bash

## To use: `ssh -p 33333 <name>@localhost` from server

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
server="tesla@yourserver.com"
port=$(cut -c 13-17 < /var/etc/vin)
localHost="localhost"
localPort=33333

while true; do
  RET=`ps ax | grep "ssh -N -T -R $localPort:$localHost:22" | grep -v "grep"`
  if [ "$RET" = "" ];then
    ssh -p $port -N -T -R $localPort:$localHost:22 -o ServerAliveInterval=3 -o StrictHostKeyChecking=no $server
  fi
  sleep 300
done
