#!/bin/sh

# Allows autosteer at all speeds
# Does not disable autopilot nag

KEY="GUI_disableAutosteerRestrictions"
WANTSTATE="true"

while true; do
  STATE=$(lv $KEY | cut -d "\"" -f2)
  if ! [ "$STATE" = "$WANTSTATE" ]; then
    sdv $KEY $WANTSTATE
    echo "Enabling $KEY $WANTSTATE"
  fi
  sleep 60
done
