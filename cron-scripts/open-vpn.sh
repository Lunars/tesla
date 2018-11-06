#!/bin/bash
/sbin/iptables -D INPUT -i tun8 -p tcp --dport 22 -j ACCEPT
/sbin/iptables -I INPUT -i tun8 -p tcp --dport 22 -j ACCEPT
/usr/sbin/openvpn --config /var/spool/tesla.ovpn --daemon

