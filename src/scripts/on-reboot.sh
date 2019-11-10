#!/bin/bash

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

homeOfLunars="/home/lunars"
scriptsOfLunars="$homeOfLunars/src/scripts"

echo "Starting reboot once scripts"
cd $scriptsOfLunars/once || exit
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
cd $scriptsOfLunars/forever || exit
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
cd $scriptsOfLunars/every5 || exit
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
