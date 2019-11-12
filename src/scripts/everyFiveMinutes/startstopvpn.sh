#!/bin/bash

file="$homeOfLunars/tesla.ovpn"
vpn=$(awk '/^dev /' $file | awk '{print $2}' )

if [ -z "$vpn" ]; then
    echo "Script not yet setup, quitting"
    exit 1
fi

if grep -q "YOURIPADDRESSHERE" $file; then
    echo "Script not yet setup, quitting"
    exit 1
fi

iptables -D INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -i $vpn -p tcp --dport 22 -j ACCEPT
/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/lunars-vpn.pid --exec /usr/sbin/openvpn -- --config $file
