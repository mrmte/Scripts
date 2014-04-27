#!/bin/bash

################### ENVIRONMENT VARIABLES #########################

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


################## DO NOT MODIFY BELOW THIS LINE ##################

# Run the command as the currently logged in user
sudo su "${user}" -c "/bin/launchctl unload /System/Library/LaunchAgents/com.apple.notificationcenterui.plist > /dev/null 2>&1"

