#!/bin/bash

# Allows autosteer at all speeds
# Does not disable autopilot nag

function watchRun() {
  # Wait until QtCarServer is running
  until pgrep QtCarServer; do
    sleep 1
  done

  sdv GUI_disableAutosteerRestrictions true
  echo "GUI_disableAutosteerRestrictions set to true"
}

function watchStop() {
  # Wait until QtCarServer is NOT running
  until [[ -z $(pgrep QtCarServer) ]]; do
    sleep 1
  done
}

while true; do
  # Run sdv if QtCarServer is running
  watchRun

  # Wait for it to restart
  watchStop
done
