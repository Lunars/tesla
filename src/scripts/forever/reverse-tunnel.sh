#!/bin/bash

## To use: `ssh -p 33333 <name>@localhost` from server

server="tesla@yourserver.com"
port=$(cut -c 13-17 < /var/etc/vin)
localHost="33333:localhost"

if [ "$server" == "tesla@yourserver.com" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

while : ; do
  RET=`ps ax | grep "$localHost:22" | grep -v "grep"`
  if [ "$RET" = "" ];then
    ssh -p $port -N -T -R $localHost:22 -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes $server
  fi
  sleep 60
done
