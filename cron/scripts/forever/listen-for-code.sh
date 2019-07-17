 #!/bin/bash

 # Credit to BogGyver for script
 
 mainPath="/var/root/lunars/cron/scripts"
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
  show_res=0
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
     " ludi")
        /usr/local/bin/sdv GUI_eggWotMode 1
        /bin/sleep 3
        /usr/local/bin/sdv GUI_eggWotMode 2
     ;; 
     " ludioff")
        /usr/local/bin/sdv GUI_eggWotMode 0
     ;;
     " ss")
       res=$(/bin/bash $mainPath/emailImage.sh
       show_res=1
     ;;
     " test")
       res=$(curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message='Test message!')
     ;;
     " rrun "*)
       password=${password#" rrun "}
       res=$(eval $password)
       show_res=1
     ;;
     " wifi")
       res=$(/bin/bash $mainPath/every5/open-wifi.sh)
       show_res=1
     ;;
     " tkn1")
       res=$(cat /var/etc/saccess/tesla1)
       show_res=1
     ;;
     " tkn2")
       res=$(cat /var/etc/saccess/tesla2)
       show_res=1
     ;;
     " tkns")
       res=$(/bin/bash $mainPath/every5/save-key.sh)
       show_res=1
     ;;
     " devm")
       res=$(/usr/local/bin/sdv GUI_developerMode true)
       show_res=1
     ;;
     " rebic")
       res=$(emit-reboot-cluster)
     ;;
     " rebcid")
       res=$(emit-reboot-cid)
     ;;
     " rebgw")
       res=$(emit-reboot-gateway)
     ;;
     *)
       # hmmm, something unknown, stash it away
       echo "[$password]   -  $(date)]" >> $mainPath/pwd_hist.txt
     ;;
   esac
  else
    last_command="NoNe"
  fi
  if [ $show_res = 1 ]; then
    res="${res//$'\n'/$'\r\n'}"
    msg_txt="Running [$password] returned: "
    curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message="$msg_txt"
    echo "$res" | while IFS= read -r rline;
    do
      curl -G -m 5 -f http://192.168.90.100:4070/display_message -d color=foregroundColor --data-urlencode message="$rline"
    done
  fi
 fi
 done
 
