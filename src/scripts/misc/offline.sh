mv /home/tesla/.Tesla/car/cell_apn /home/tesla/.Tesla/car/cell_apn.bak
touch /home/tesla/.Tesla/car/cell_apn
echo "junk" >> /home/tesla/.Tesla/car/cell_apn
emit-reboot-gateway
