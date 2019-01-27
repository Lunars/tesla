#!/bin/bash

if [ ! -f /etc/tegraline-release ]
then
  touch /etc/tegraline-release
fi

if [ ! -f /var/etc/disable-seceth ]
then
  touch /var/etc/disable-seceth
fi
