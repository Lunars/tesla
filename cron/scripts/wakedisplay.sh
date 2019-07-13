#this script will wake your bench cid display if you add it to cron.
#@reboot bash /var/root/lunars/cron/scripts/wakedisplay.sh
curl -L "http://192.168.90.100:4070/_data_set_value_request_?name=CD_displayState&value=2"
