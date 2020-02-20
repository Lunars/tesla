#!/bin/sh

# This script makes your VPN go over cell connection instead of wifi
# Useful for when your car goes in to service and you still want to access SSH
# Service center wifi does not usually let outgoing / incoming connections
DHCPLEASES="/var/lib/dhcp3/dhclient.wwan0.leases"
OVPN="$homeOfLunars/tesla.ovpn"

if grep -q "YOURIPADDRESSHERE" $OVPN; then
  echo "openvpn not yet setup, quitting"
  exit 1
fi

function addVPNRoute() {
  VPNIP=$(awk '/^remote /' $OVPN | awk '{print $2}')
  CELLIP=$(ip r | grep wwan0 | grep -Pom 1 '[0-9.]{7,15}' | tail -1)

  service openvpn stop
  route delete $VPNIP >/dev/null 2>&1

  if [ ! -z "$CELLIP" ]; then
    ROUTERIP=$(grep $CELLIP -A 3 $DHCPLEASES | tail -1 | grep -Pom 1 '[0-9.]{7,15}')
    route add $VPNIP gw $ROUTERIP
  fi

  service openvpn start
}

# Called once at least on start, so that the appropriate routes can be added
addVPNRoute

while inotifywait -e modify $DHCPLEASES; do
  echo "Found cell change, updating route"
  addVPNRoute
done
