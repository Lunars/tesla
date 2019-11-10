#!/bin/bash

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# Pull in global vars
mydir="${0%/*}"
source "$mydir"/../config.sh

echo "Starting reboot once scripts"
cd $homeOfLunars/scripts/once || exit
for f in *.sh; do
    echo "Found $f"
    # check if already running
    if ps ax | grep "$f" | grep -v $$ | grep bash | grep -v grep; then
        echo "The script [$f] is already running."
        break
    else
        echo "Running $f..."
        /bin/bash "$f" >/dev/null 2>&1
    fi
done

echo "Starting reboot forever scripts"
cd $homeOfLunars/scripts/forever || exit
for f in *.sh; do
    echo "Found $f"
    # check if already running
    if ps ax | grep "$f" | grep -v $$ | grep bash | grep -v grep; then
        echo "The script [$f] is already running."
    else
        echo "Starting $f..."
        /bin/bash "$f" >/dev/null 2>&1 &
    fi
done

echo "Starting 5 minute scripts"
cd $homeOfLunars/scripts/every5 || exit
while true; do
    for f in *.sh; do
        echo "Found $f"
        # check if already running
        if ps ax | grep "$f" | grep -v $$ | grep bash | grep -v grep; then
            echo "The script [$f] is already running."
        else
            echo "Starting $f..."
            /bin/bash "$f" >/dev/null 2>&1
        fi
    done
    echo "Waiting 5 minutes"
    sleep 300
done
