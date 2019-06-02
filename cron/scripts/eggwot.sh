#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# Mode 1 shows the battery temperature level on the IC display, as a purple indicator on the same menu as the energy graph
# Mode 2 does what 1 does, in addition to showing drive unit statistics on the left IC menu

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
