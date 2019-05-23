#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

STATE=$(/usr/local/bin/lv GUI_eggWotMode | cut -d "\"" -f2)
WANTSTATE="Preparing"
MODE=1

echo "state is" $STATE
echo "state wanted is" $WANTSTATE

if ! [ "$STATE" = "$WANTSTATE" ] ; then
   /usr/local/bin/sdv GUI_eggWotMode $MODE
   echo "Enabling GUI_eggWotMode $MODE"
else
   echo "Already Enabled"
fi
