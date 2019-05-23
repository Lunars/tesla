#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

STATE=$(/usr/local/bin/lv GUI_eggWotMode | cut -d "\"" -f2)
WANTSTATE="Preparing"

echo "state is" $STATE
echo "state wanted is" $WANTSTATE

if ! [ "$STATE" = "$WANTSTATE" ] ; then
   /usr/local/bin/sdv GUI_eggWotMode 1
   echo "Enabling GUI_eggWotMode 1"
else
   echo "Already Enabled"
fi
