#!/bin/bash

# Credit to FreedomEV for the install script
echo Script to install Lunars

# Detect if we are running chrooted by checking if the root of the init process is the same as the root of this process
if [[ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]] 
then
 echo This is not supposed to run chrooted
 exit 2
fi

echo Not running chrooted: OK

alreadyinstalled=$(crontab -l | grep /var/root/lunars)
if [[ "$alreadyinstalled" != "" ]]
then
	echo Lunars repo is already installed: installation aborted
	exit 3
fi

echo Not yet installed: OK

# Downloading repo to CID
mkdir -p /var/root/lunars
curl -SL https://github.com/Lunars/tesla/tarball/master -o lunars.zip
tar xvf ./lunars.zip -C /var/root/lunars/
rm ./lunars.zip
mv /var/root/lunars/Lunars-tesla*/* /var/root/lunars/
rm -rf /var/root/lunars/Lunars-tesla*

# Installing crontab
crontab -l > /tmp/crontab
echo '@reboot /bin/bash /var/root/lunars/src/scripts/on-reboot.sh > /dev/null 2>&1 &' >> /tmp/crontab
cat /tmp/crontab | crontab || exit 6
echo Crontab installed: OK

# Starting scripts
/bin/bash /var/root/lunars/src/scripts/on-reboot.sh > /dev/null 2>&1 &
echo Lunars installed! Have fun!