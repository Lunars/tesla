#!/bin/bash

# When on a wifi network, this script will allow you to ssh to the local ip
# You have to be on the same wifi network as the car
# Uses port $WIFIPORT for ssh
# Useful if you're on the road and you open a hotspot on your phone, then connect car to phone's wifi hotspot. Now you can ssh to the car

# ssh -p $WIFIPORT tesla1@192.168.1.154

WIFIPORT=229
PARROTIP=192.168.20.2

iptables -D INPUT -i parrot -p tcp -m tcp --dport 22 -j ACCEPT
iptables -I INPUT -i parrot -p tcp -m tcp --dport 22 -j ACCEPT

{
  echo
  sleep 1
  echo
  sleep 1
  echo "iptables -t nat -D PREROUTING -i mlan0 -p tcp -m tcp --dport $WIFIPORT -j DNAT --to-destination $PARROTIP:22"
  sleep 1
  echo "iptables -t nat -I PREROUTING -i mlan0 -p tcp -m tcp --dport $WIFIPORT -j DNAT --to-destination $PARROTIP:22"
  sleep 1
  echo "iptables -D INPUT -p tcp --dport $WIFIPORT -j ACCEPT"
  sleep 1
  echo "iptables -I INPUT -p tcp --dport $WIFIPORT -j ACCEPT"
  sleep 1
} | socat - tcp:parrot:telnet
