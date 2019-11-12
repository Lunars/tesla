#!/bin/bash

# Pull in global vars
mydir="${0%/*}"
source "$mydir"/../config.sh

function isRunning {
    process=$(ps ax | grep "$1" | grep -v $$ | grep bash | grep -v grep)
    [ ! -z "$process" ]
}

function scriptBackground {
    bash "$1" >/dev/null 2>&1 &
}

function beginScript {
    printf "Found $1... "
    if ! isRunning $1; then
        printf "Starting\n"
        scriptBackground $1
    else
        printf "Already running\n"
    fi
}

function main {
    for scriptPath in "${scheduledScripts[@]}"; do
        beginScript $scriptPath
    done

    # Five minutes
    while true; do
        for scriptPath in "${everyFiveMinuteScripts[@]}"; do
            beginScript $scriptPath
        done
        echo "Waiting 5 minutes..."
        sleep 300
    done
}

main
