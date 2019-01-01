#!/bin/bash

# Turns developer modes on after each restart. Add to your crontab @reboot.

/bin/sleep 30
/usr/local/bin/sdv GUI_developerMode true

# It's not yet clear what DAS developer mode does, so leave it off by default.
#/usr/local/bin/sdv GUI_dasDeveloper true
