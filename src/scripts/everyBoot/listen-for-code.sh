#!/bin/bash

# shellcheck disable=SC2154
function initializeVariables() {
  mainPath="$homeOfLunars/scripts"
  pattern="AccessPopup"
  defaultFalse="NoNe"
  lastCommand=$defaultFalse
}

function showMessage() {
  curl -G -m 5 -f "http://192.168.90.100:4070/display_message" -d color=foregroundColor --data-urlencode message="$1"
}

function findCommand() {
  password=$1
  res=$defaultFalse
  case $password in
  $defaultFalse)
    echo "Got $defaultFalse"
    ;;
  " resetpw")
    echo "root:root" | chpasswd
    res="root password: root"
    ;;
  " egg2")
    sdv GUI_eggWotMode 1
    sleep 2
    sdv GUI_eggWotMode 2
    ;;
  " egg1")
    sdv GUI_eggWotMode 1
    ;;
  " egg0")
    sdv GUI_eggWotMode 0
    ;;
  " ss")
    res=$(bash "$mainPath"/misc/upload-screenshots.sh)
    ;;
  " wipeupdate")
    bash "$mainPath"/misc/wipe-update.sh
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
    res=$(eval "$password")
    ;;
  " wifi")
    res=$(bash "$mainPath"/everyFiveMinutes/open-wifi.sh)
    ;;
  " tkn1")
    res=$(cat /var/etc/saccess/tesla1)
    ;;
  " tkn2")
    res=$(cat /var/etc/saccess/tesla2)
    ;;
  " tkns")
    res=$(bash "$mainPath"/everyBoot/tokens-to-php.sh)
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
  " help")
    # Get all commands from this file
    res=$(grep -o '" .*")' "$mainPath"/everyBoot/listen-for-code.sh | tr -d '") ')
    # Replace newlines
    res="${res//$'\n'/ }"
    res=$(echo "$res" | tr " " "\n")
    ;;
  *)
    # hmmm, something unknown, stash it away
    echo "$(date) - $password" >>"$mainPath"/pwd_hist.txt
    ;;
  esac
}

function looper() {
  msg=$(tail -n 100 /var/log/syslog | grep "access code" | grep -m1 $pattern)
  if [[ $msg != *$pattern* ]]; then
    lastCommand=$defaultFalse
    return
  fi

  password=$(echo "$msg" | awk -F':' '{ print $6 }')

  # Don't allow the same password twice
  # @TODO: Remove this check to allow the same command multiple times
  [[ $password == "$lastCommand" ]] && password=$defaultFalse || lastCommand=$password

  # This sets $res
  findCommand $password

  # I think we can display messages by using clogger
  # DISPLAY_REPORT=yes clogger "message goes here"
  if [ "$res" != $defaultFalse ]; then
    showMessage "Running [$password] returned: "
    res="${res//$'\n'/$'\r\n'}"
    echo "$res" | while IFS= read -r rline; do
      showMessage "$rline"
    done
  fi

  res=$defaultFalse
}

function main() {
  initializeVariables

  while inotifywait -q -q -e modify /var/log/syslog; do
    looper
  done
}

main
