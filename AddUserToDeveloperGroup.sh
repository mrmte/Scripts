#!/bin/bash
#### This script will add the current user to the _developer group.
#### Only needed with users using xcode.

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


# Check to see if the user is in the group
if
dscl . -read /Groups/_developer GroupMembership | grep $user ;then
echo "$user is already a member!"
else
dscl . append /Groups/_developer GroupMembership $user
fi

# Enable Debugging Developer Tools
DevToolsSecurity -enable

exit 0

