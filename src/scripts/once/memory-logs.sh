#!/bin/bash

# mount /var/log on tmpfs to not wear down the eMMC flash chip

ENABLE=true

if [ "$ENABLE" == "false" ]; then
    echo "Script not enabled, quitting"
    exit 1
fi

ISTMPFS=$(/bin/mount | /bin/grep -c "/var/log type tmpfs")

if [ "$ISTMPFS" == 0 ]; then
  /bin/mount -t tmpfs -o size=100M tmpfs /var/log; /sbin/initctl restart rsyslog
  kill $(cat /etc/sv/camera0-capture/log/supervise/pid)
  kill $(cat /etc/sv/camera1-capture/log/supervise/pid)
  kill $(cat /etc/sv/camera2-capture/log/supervise/pid)
  kill $(cat /etc/sv/camera3-capture/log/supervise/pid)
  kill $(cat /etc/sv/crashloghelper/log/supervise/pid)
  kill $(cat /etc/sv/crashlognotify/log/supervise/pid)
  kill $(cat /etc/sv/dashcam/log/supervise/pid)
  kill $(cat /etc/sv/hermes-client/log/supervise/pid)
  kill $(cat /etc/sv/hermes-eventlogs/log/supervise/pid)
  kill $(cat /etc/sv/hermes-grablogs/log/supervise/pid)
  kill $(cat /etc/sv/hermes-historylogs/log/supervise/pid)
  kill $(cat /etc/sv/hermes-proxy/log/supervise/pid)
  kill $(cat /etc/sv/hermes-teleforce/log/supervise/pid)
  kill $(cat /etc/sv/odin-engine/log/supervise/pid)
  kill $(cat /etc/sv/usbupdate-server/log/supervise/pid)
  echo SYSLOG now on TMPFS
else
  echo SYSLOG already on TMPFS
fi
