#!/bin/bash

cidIp="192.168.90.100"
cidPort="4070"
mainPath="$homeOfLunars/scripts"
pattern=AccessPopup
last_command="NoNe"
if ps ax | grep $0 | grep -v $$ | grep bash | grep -v grep
then
    echo "The script is already running."
    exit 1
fi

while true; do
if  inotifywait -q -q -e modify /var/log/syslog; then
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
      echo "root:root"|chpasswd
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
      res=$(/bin/bash $mainPath/upload-screenshots.sh)
    ;;
    " wipeupdate")
      /bin/bash $mainPath/wipe-update.sh
      res="Update got wiped"
    ;;
    " vlow")
      sdv GUI_suspensionLevelRequest 7
    ;;
    " test")
      res="Test message!"
    ;;
    " help")
      res="resetpw devm egg0 egg1 egg2 rebic rebcid rebgw rrun ss tkn1 tkn2 tkns vlow wifi wipeupdate factory unfactory ip"
    ;;
    " rrun "*)
      password=${password#" rrun "}
      res=$(eval $password)
    ;;
    " wifi")
      res=$(/bin/bash $mainPath/every5/open-wifi.sh)
    ;;
    " tkn1")
      res=$(cat /var/etc/saccess/tesla1)
    ;;
    " tkn2")
      res=$(cat /var/etc/saccess/tesla2)
    ;;
    " tkns")
      res=$(/bin/bash $mainPath/every5/save-key.sh)
    ;;
    " devm")
      sdv GUI_developerMode true
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
    *)
      # hmmm, something unknown, stash it away
      echo "$(date) - $password" >> $mainPath/pwd_hist.txt
    ;;
  esac
 else
   last_command="NoNe"
 fi
 if [ "$res" != "NoNe" ]; then
   res="${res//$'\n'/$'\r\n'}"
   msg_txt="Running [$password] returned: "
   curl -G -m 5 -f http://${cidIp}:${cidPort}/display_message -d color=foregroundColor --data-urlencode message="$msg_txt"
   echo "$res" | while IFS= read -r rline;
   do
     curl -G -m 5 -f http://${cidIp}:${cidPort}/display_message -d color=foregroundColor --data-urlencode message="$rline"
   done
 fi
fi
done
