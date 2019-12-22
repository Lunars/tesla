#!/bin/bash

# Set up a reverse SSH tunnel to a remote server
# Make sure the user tesla (default) can log in without a password
#
# On that server SSH back to your car using:
# ssh -p <last4ofvin> <name>@localhost

if [[ "$reverseTunnelServer" =~ "yourserver.com" ]]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

# Fix for leading 0 digit making it a 3 char port
nonStandardPort=$(echo $nonStandardPort | sed 's/^0*/1/')

while :; do
  RET=$(ps ax | grep "${nonStandardPort}:localhost:22" | grep -v "grep" | wc -l)
  if [ "$RET" -eq 0 ]; then
    ssh -N -T -R ${nonStandardPort}:localhost:22 -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes $reverseTunnelServer
  fi
  sleep 60
done
