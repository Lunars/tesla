# This script will wake your bench cid display 

ENABLE=false

if [ "$ENABLE" == "false" ]; then
    echo "Script not enabled, quitting"
    exit 1
fi

curl -sL "http://192.168.90.100:4070/_data_set_value_request_?name=CD_displayState&value=2"
