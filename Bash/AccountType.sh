#!/bin/bash

################## ENVIRONMENT VARIABLES ####################

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

accountType=`dscl . -read /Users/"$user" | grep UniqueID | cut -c 11-`

##################################################################

if [ "$accountType" -gt 1000 ]; then
echo "The current user is a Mobile Cached Account"

elif [ "$accountType" -lt 1000 ]; then
echo "The current user is a Local Account"

fi
