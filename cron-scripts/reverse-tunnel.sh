#!/bin/bash

## To use: `ssh -p 33333 <name>@localhost` from server

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

while : ; do
ssh -N -T -R 33333:localhost:22 -i ./.ssh/<YOUR KEY> -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes <USER>@<YOUR SERVER>
sleep 60
done

