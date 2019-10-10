#!/bin/bash
if (($(cat /proc/uptime | cut -d. -f1) < 60)); then sleep 15; fi

file="/home/lunars/src/tesla.ovpn"
vpn="tun8"

if grep -q "YOURIPADDRESSHERE" $file; then
    echo "Script not yet setup, quitting"
    exit 1
fi

iptables -D INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/rob-vpn.pid --exec /usr/sbin/openvpn -- --config $file
