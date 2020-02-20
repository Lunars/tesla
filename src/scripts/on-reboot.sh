#!/bin/sh

# Pull in global vars
mydir="${0%/*}"
source "$mydir"/../config.sh

function isRunning() {
  process=$(ps ax | grep "$1" | grep -v $$ | grep sh | grep -v grep)
  [ -n "$process" ]
}

function scriptBackground() {
  sh "$1" >/dev/null 2>&1 &
}

function beginScript() {
  echo "Found $1... "
  if ! isRunning "$1"; then
    echo "Starting"
    scriptBackground "$1"
  else
    echo "Already running"
  fi
}

function main() {
  echo "Starting Lunars"

  # Some of our scripts need CRON to work, such as the auto updater or token updater
  echo "Waiting for internet before continuing..."
  i=0
  while [ $i -lt 5 ]; do
    if check-internet parrot || check-internet wwan0 || check-internet ppp0; then
      echo "Found internet"
      break
    fi;

    ((i++));
    if [[ "$i" == '5' ]]; then
      echo "Cancelling internet check as no connection was found within 5 minutes"
      break
    fi

    echo "Sleeping for 1m waiting for internet"
    sleep 60
  done

  echo "Continuing with Lunars startup"

  for scriptPath in "${scheduledScripts[@]}"; do
    beginScript "$scriptPath"
  done

  # Five minutes
  while true; do
    for scriptPath in "${everyFiveMinuteScripts[@]}"; do
      beginScript "$scriptPath"
    done
    echo "Waiting 5 minutes..."
    sleep 300
  done
}

main
