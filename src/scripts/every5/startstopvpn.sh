#!/bin/bash
if (($(cat /proc/uptime | cut -d. -f1) < 60)); then sleep 15; fi

file="/var/root/lunars/src/tesla.ovpn"

if grep -q "YOURIPADDRESSHERE" $file; then
    echo "Script not yet setup, quitting"
    exit 1
fi

/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/rob-vpn.pid --exec /usr/sbin/openvpn -- --config $file
