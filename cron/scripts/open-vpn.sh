#!/bin/bash

# Save your own config to /var/spool/tesla.ovpn

if (( $(cat /proc/uptime | cut -d. -f1) < 60 )); then sleep 15; fi

/sbin/iptables -D INPUT -i tun8 -p tcp --dport 22 -j ACCEPT
/sbin/iptables -I INPUT -i tun8 -p tcp --dport 22 -j ACCEPT
/usr/sbin/openvpn --config /var/spool/tesla.ovpn --daemon
