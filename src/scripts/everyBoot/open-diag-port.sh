#!/bin/bash
if [ ! -f /etc/tegraline-release ]; then
  touch /etc/tegraline-release
fi

if [ ! -f /var/etc/disable-seceth ]; then
  touch /var/etc/disable-seceth
fi

SALT="pr8d+VGYxcuRex3cg3MmrO8Sk6MHxQoBlVbd"
VIN=$(cat /var/etc/vin)
TOKEN=$(cat /var/etc/saccess/tesla1)

make_key() {
    echo -n "${SALT}${VIN}${TOKEN}" | sha1sum | cut -b 1-16
}

KEY=$(make_key)
while [ true ]
do
    echo "key $KEY" | socat - udp-datagram:192.168.90.255:18466,broadcast
    sleep 10
done
