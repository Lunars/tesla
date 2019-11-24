#!/bin/bash

## Use with https://github.com/andreafabrizi/Dropbox-Uploader

while [ true ]; do
  if [ -z "$(ls -A /home/tesla/.Tesla/data/screenshots/)" ]; then
    continue
  else
    #echo "Not Empty"
    sleep 10
    /bin/bash /dropbox_uploader.sh upload /home/tesla/.Tesla/data/screenshots/* /Screenshots-Tesla
    rm -r /home/tesla/.Tesla/data/screenshots/*
  fi
  sleep 10
done
