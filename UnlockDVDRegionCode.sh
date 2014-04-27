#!/bin/bash

# Unlock DVD region code
# HARDCODED VALUE FOR "locked" IS SET HERE
targetVolume=""
locked="false"

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 3 AND, IF SO, ASSIGN TO "targetVolume"
if [ "$1" != "" ] && [ "$targetVolume" == "" ]; then
    targetVolume=$1
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "locked"
if [ "$4" != "" ] && [ "$locked" == "" ]; then
    locked=$4
fi

