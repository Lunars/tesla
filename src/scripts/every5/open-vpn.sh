#!/bin/bash

# Save your own config to /var/spool/tesla.ovpn
file="/var/root/lunars/src/tesla.ovpn"
vpn="tun8"

if (( $(cat /proc/uptime | cut -d. -f1) < 60 )); then sleep 15; fi

/sbin/iptables -D INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
/sbin/iptables -I INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
/usr/sbin/openvpn --config $file --daemon
