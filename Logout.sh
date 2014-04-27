#!/bin/bash


#################### ENVIRONMENT VARIABLES #########################

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Specify the command
command=`osascript -e 'tell application "System Events" to log out'`

################## DO NOT MODIFY BELOW THIS LINE ##################

# Run the command as the currently logged in user

sudo su "${user}" -c "${command}"

exit 0
