#!/bin/bash

# When on a wifi network, this script will allow you to ssh to the local ip 
# You have to be on the same wifi network as the car 
# Uses port 229 for ssh
# Useful if you're on the road and you open a hotspot on your phone, then connect car to phone's wifi hotspot. Now you can ssh to the car 

# ssh -p 229 tesla1@192.168.1.154 

if (( $(cat /proc/uptime | cut -d. -f1) < 60 )); then sleep 15; fi

/sbin/iptables -D INPUT -i parrot -p tcp -m tcp --dport 22 -j ACCEPT
/sbin/iptables -I INPUT -i parrot -p tcp -m tcp --dport 22 -j ACCEPT
{ echo; sleep 1; echo; sleep 1; echo "iptables -t nat -D PREROUTING -i mlan0 -p tcp -m tcp --dport 229 -j DNAT --to-destination 192.168.20.2:22"; sleep 1; echo "iptables -t nat -I PREROUTING -i mlan0 -p tcp -m tcp --dport 229 -j DNAT --to-destination 192.168.20.2:22"; sleep 1; echo "iptables -D INPUT -p tcp --dport 229 -j ACCEPT"; sleep 1; echo "iptables -I INPUT -p tcp --dport 229 -j ACCEPT"; sleep 1; } | socat - tcp:parrot:telnet
