#!/bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# By Adding the user to the App store group they will not be prompted for admin rights!
dscl . -append /Groups/_appstore GroupMembership $user

exit 0
