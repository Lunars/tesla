#! bin/bash
# mount /var/log on tmpfs to not wear down the eMMC flash chip
ISTMPFS=`/bin/mount | /bin/grep -c "/var/log type tmpfs"`

if [ $ISTMPFS == 0 ]; then
  /bin/mount -t tmpfs -o size=100M tmpfs /var/log; /sbin/initctl restart rsyslog
  echo SYSLOG now on TMPFS
else
  echo SYSLOG already on TMPFS
fi
