#!/bin/bash

# Run this if you have an update you want to kill

initctl stop cid-updater && rm -rf /var/spool/*-updater/* && initctl start cid-updater
ssh root@ic "initctl stop ic-updater && rm -rf /var/spool/*-updater/* && initctl start ic-updater"
