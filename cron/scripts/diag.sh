#!/bin/bash

# This can generate an unlock token if you ever need one
# This script is typically useless once you're rooted
# Use open-diag-port.sh instead

SALT="pr8d+VGYxcuRex3cg3MmrO8Sk6MHxQoBlVbd"
VIN=$(< /var/etc/vin)
TOKEN=$(< /var/etc/saccess/tesla1)

make_key() {
    echo -n "${SALT}${VIN}${TOKEN}" | sha1sum | cut -b 1-16
}
KEY=$(make_key)
echo "key $KEY"
while [ true ]
do
    echo "key $KEY" | socat - udp-datagram:192.168.90.255:18466,broadcast
    sleep 10
done
​
