#!/bin/bash

#################### ENVIRONMENT VARIABLES #########################

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Specify the command
command='defaults write com.apple.appstore ShowDebugMenu -bool true'

################## DO NOT MODIFY BELOW THIS LINE ##################

# Run the command as the currently logged in user
sudo su "${user}" -c "${command}"


exit 0
