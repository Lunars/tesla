#!/bin/bash
if (( $(cat /proc/uptime | cut -d. -f1) < 60 )); then sleep 15; fi

/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/rob-vpn.pid --exec /usr/sbin/openvpn -- --config /var/spool/tesla.ovpn
