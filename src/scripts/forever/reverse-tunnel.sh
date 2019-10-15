#!/bin/bash
#
# Set up a reverse SSH tunnel to a remote server
#
# Make sure the user tesla (default) can log in without a password
#
# On that server SSH back to your car using:
#
# ssh -p <last4ofvin> <name>@localhost

ENABLE=false

if [ "$ENABLE" != "true" ]; then
    echo "Script not enabled, quitting"
    exit 1
fi

server="tesla@yourserver.com"
port=$(cut -c 13-17 < /var/etc/vin)

while : ; do
  RET=$(ps ax | grep "${port}:localhost:22" | grep -v "grep"|wc -l)
  if [ "$RET" -eq 0 ];then
    ssh -N -T -R ${port}:localhost:22 -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes $server -p $port
  fi
  sleep 60
done
