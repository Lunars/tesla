#! bin/bash
# Block Tesla from SSHing to car
/sbin/iptables -D INPUT -i tun0 -p tcp -m tcp --dport 22 -j REJECT --reject-with icmp-port-unreachable
/sbin/iptables -D INPUT -i tun0 -p tcp -m tcp --dport 22 -j LOG
/sbin/iptables -I INPUT -i tun0 -p tcp -m tcp --dport 22 -j REJECT --reject-with icmp-port-unreachable
/sbin/iptables -I INPUT -i tun0 -p tcp -m tcp --dport 22 -j LOG
