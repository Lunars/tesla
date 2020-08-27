#!/bin/bash

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# Changed from /home/ because a factory reset will wipe out Lunars in /home/ but will remain in /var/
export homeOfLunars="/var/lunars"

## create-accounts.sh
# Recommend you fill this out for easier SSH to your car
export keyToSaveToCar="ssh-rsa first example"
export accountUserToSaveToCar="yourUsername"
export accountPassToSaveToCar="myCarIsRooted"

## reverse-tunnel.sh
# Could be used on other files in the future
export nonStandardPort=$(cut -c 14-17 </var/etc/vin | sed 's/^0/1/')

## vitals-to-php.sh
# Save src/save-vitals.php to your public server
export urlToVitalsPHP="http://yourserver.com/path/save-vitals.php"

## tokens-to-php.sh
# Save src/save-tokens.php to your public server
export urlToTokensPHP="http://yourserver.com/path/save-tokens.php"

## reverse-tunnel.sh
export reverseTunnelServer="tesla@yourserver.com -p 22"

## save-key-over-ssh.sh
export saveTokenOverSshFile="tesla-keys.txt"
export saveTokenOverSshServer="tesla@yourserver.com -p 22"

scheduledScripts=(
  "$homeOfLunars/scripts/everyBoot/memory-logs.sh"
  "$homeOfLunars/scripts/everyBoot/mount-modfiles.sh"
  "$homeOfLunars/scripts/everyBoot/open-diag-port.sh"
  "$homeOfLunars/scripts/everyBoot/create-accounts.sh"
  "$homeOfLunars/scripts/everyBoot/check-for-updates.sh"
  "$homeOfLunars/scripts/everyBoot/speed-sensitive-volume.sh"
  "$homeOfLunars/scripts/everyBoot/tokens-to-php.sh"
  "$homeOfLunars/scripts/everyBoot/autopilot-autosteer.sh"
  #    "$homeOfLunars/scripts/everyBoot/save-key-over-ssh.sh"
  #    "$homeOfLunars/scripts/everyBoot/copy-tokens-to-ic.sh"
  #    "$homeOfLunars/scripts/everyBoot/block-tesla-ssh.sh"
  #    "$homeOfLunars/scripts/everyBoot/freedomevstart.sh"
  #    "$homeOfLunars/scripts/everyBoot/wake-bench.sh"
  #    "$homeOfLunars/scripts/everyBoot/listen-for-code.sh"
  #    "$homeOfLunars/scripts/everyBoot/reverse-tunnel.sh"
  #    "$homeOfLunars/scripts/everyBoot/vpn-over-cell.sh"
)

everyFiveMinuteScripts=(
  "$homeOfLunars/scripts/everyFiveMinutes/open-wifi.sh"
  "$homeOfLunars/scripts/everyFiveMinutes/startstopvpn.sh"
  "$homeOfLunars/scripts/everyFiveMinutes/vitals-to-php.sh"
  #    "$homeOfLunars/scripts/everyFiveMinutes/add-swblock.sh"
  #    "$homeOfLunars/scripts/everyFiveMinutes/eggwot.sh"
)
