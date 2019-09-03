#!/bin/bash

# Save your own config to /var/spool/tesla.ovpn
file="/var/root/lunars/src/tesla.ovpn"
vpn="tun8"

if grep -q "YOURIPADDRESSHERE" $file; then
    echo "Script not yet setup, quitting"
    exit 1
fi

if (( $(cat /proc/uptime | cut -d. -f1) < 60 )); then sleep 15; fi

iptables -D INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
openvpn --config $file --daemon
