#!/bin/bash

/sbin/start-stop-daemon --start --quiet --make-pidfile --oknodo --background --pidfile /var/run/rob-vpn.pid --exec /usr/sbin/openvpn -- --config /var/spool/tesla.ovpn
