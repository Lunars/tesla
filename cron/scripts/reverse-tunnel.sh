#!/bin/bash

## To use: `ssh -p 33333 <name>@localhost` from server

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

while true; do
  RET=`ps ax | grep "ssh -N -T -R 33333:localhost:22" | grep -v "grep"`
  if [ "$RET" = "" ];then
    ssh -N -T -R 33333:localhost:22 -i /home/pkiley/.ssh/id_rsa -o ServerAliveInterval=3 -o StrictHostKeyChecking=no ubuntu@52.36.7.222
  fi
  sleep 300
done
