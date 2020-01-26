#!/bin/bash

# revert and reboot only if initial backup was taken from offline.sh
if [ -f /home/tesla/.Tesla/car/cell_apn.bak ]; then
	mv /home/tesla/.Tesla/car/cell_apn.bak /home/tesla/.Tesla/car/cell_apn
	emit-reboot-gateway
fi
