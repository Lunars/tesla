#!/bin/bash

cidIp="192.168.90.100"
cidPort="4070"
# shellcheck disable=SC2154
mainPath="$homeOfLunars/scripts"
pattern=AccessPopup
last_command="NoNe"
if ps ax | grep $0 | grep -v $$ | grep bash | grep -v grep; then
  echo "The script is already running."
  exit 1
fi

while true; do
  if inotifywait -q -q -e modify /var/log/syslog; then
    msg=$(tail -n 100 /var/log/syslog | grep "access code" | grep -m1 $pattern)
    res="NoNe"
    if [[ $msg == *$pattern* ]]; then
      password=$(echo $msg | awk -F':' '{ print $6 }')
      if [[ $password == $last_command ]]; then
        password="NoNe"
      else
        last_command=$password
      fi
      case $password in
      "NoNe")
        echo "Got NoNe"
        ;;
      " resetpw")
        echo "root:root" | chpasswd
        res="root password: root"
        ;;
      " egg2")
        sdv GUI_eggWotMode 1
        /bin/sleep 2
        sdv GUI_eggWotMode 2
        ;;
      " egg1")
        sdv GUI_eggWotMode 1
        ;;
      " egg0")
        sdv GUI_eggWotMode 0
        ;;
      " ss")
        res=$(/bin/bash $mainPath/misc/upload-screenshots.sh)
        ;;
      " wipeupdate")
        /bin/bash $mainPath/misc/wipe-update.sh
        res="Update got wiped"
        ;;
      " vlow")
        sdv GUI_suspensionLevelRequest 7
        ;;
      " test")
        res="Test message!"
        ;;
      " rrun "*)
        password=${password#" rrun "}
        res=$(eval $password)
        ;;
      " wifi")
        res=$(/bin/bash $mainPath/everyFiveMinutes/open-wifi.sh)
        ;;
      " tkn1")
        res=$(cat /var/etc/saccess/tesla1)
        ;;
      " tkn2")
        res=$(cat /var/etc/saccess/tesla2)
        ;;
      " tkns")
        res=$(/bin/bash $mainPath/everyBoot/tokens-to-php.sh)
        ;;
      " vitals")
        res=$(/bin/bash $mainPath/everyBoot/vitals-to-php.sh)
        ;;
      " devm")
        sdv GUI_developerMode true
        ;;
      " rebparrot")
        emit-restart-parrot
        ;;
      " rebmodem")
        modem-power cycle
        ;;
      " rebic")
        emit-reboot-cluster
        ;;
      " rebcid")
        emit-reboot-cid
        ;;
      " rebgw")
        emit-reboot-gateway
        ;;
      " factory")
        sdv GUI_factoryMode true
        touch /home/tesla/factoryMode
        emit-reboot-cid
        ;;
      " unfactory")
        sdv GUI_factoryMode false
        rm /home/tesla/factoryMode
        emit-reboot-cid
        ;;
      " ip")
        res=$(ip addr show)
        ;;
      " offline")
        mv /home/tesla/.Tesla/car/cell_apn /home/tesla/.Tesla/car/cell_apn.bak
        touch /home/tesla/.Tesla/car/cell_apn
        emit-reboot-gateway
        ;;
      " online")
        mv /home/tesla/.Tesla/car/cell_apn.bak /home/tesla/.Tesla/car/cell_apn
        emit-reboot-gateway
        ;;
      " help")
        res=$(grep -o '" .*")' "$mainPath"/everyBoot/listen-for-code.sh | tr -d '") ') # Get all commands from this file
        res="${res//$'\n'/ }"                                                        # Replace newlines
        ;;
      *)
        # hmmm, something unknown, stash it away
        echo "$(date) - $password" >>$mainPath/pwd_hist.txt
        ;;
      esac
    else
      last_command="NoNe"
    fi
    if [ "$res" != "NoNe" ]; then
      res="${res//$'\n'/$'\r\n'}"
      msg_txt="Running [$password] returned: "
      curl -G -m 5 -f http://${cidIp}:${cidPort}/display_message -d color=foregroundColor --data-urlencode message="$msg_txt"
      echo "$res" | while IFS= read -r rline; do
        curl -G -m 5 -f http://${cidIp}:${cidPort}/display_message -d color=foregroundColor --data-urlencode message="$rline"
      done
    fi
  fi
done
