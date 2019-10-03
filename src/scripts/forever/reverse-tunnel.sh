#!/bin/bash
#
# Set up a reverse SSH tunnel to a remote server
#
# Make sure the user tesla (default) can log in without a password
#
# On that server SSH back to your car using:
#
# ssh -p <last4ofvin> <name>@localhost

server="tesla@yourserver.com"
port=$(cut -c 14-17 < /var/etc/vin)

if [ "$server" == "tesla@yourserver.com" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

while : ; do
  RET=`ps ax | grep "${port}:localhost:22" | grep -v "grep"`
  if [ "$RET" = "" ];then
    ssh -N -T -R ${port}:localhost:22 -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes $server
  fi
  sleep 60
done
