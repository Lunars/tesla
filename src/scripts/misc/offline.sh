#!/bin/bash

# Do not overwrite back up if already taken.
if [ ! -f /home/tesla/.Tesla/car/cell_apn.bak ]; then
	mv /home/tesla/.Tesla/car/cell_apn /home/tesla/.Tesla/car/cell_apn.bak
	echo "junk" > /home/tesla/.Tesla/car/cell_apn
	emit-reboot-gateway
fi
