#!/bin/sh

# Block Tesla from SSHing to car
iptables -D INPUT -i tun0 -p tcp -m tcp --dport 22 -j REJECT --reject-with icmp-port-unreachable
iptables -D INPUT -i tun0 -p tcp -m tcp --dport 22 -j LOG
iptables -I INPUT -i tun0 -p tcp -m tcp --dport 22 -j REJECT --reject-with icmp-port-unreachable
iptables -I INPUT -i tun0 -p tcp -m tcp --dport 22 -j LOG
