# This script will wake your bench cid display 

ENABLE=false

if [ "$ENABLE" == "false" ]; then
    echo "Script not enabled, quitting"
    exit 1
fi

sdv CD_displayState 2
