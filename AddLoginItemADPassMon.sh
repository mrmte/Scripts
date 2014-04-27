#!/bin/bash

######################### HISTORY ###############################
#                                                               #
# Created by Tim Kimpton 13/10/2012                              #
#                                                               #
# Open an application ass the currently logged in user          #
#                                                               #
################### Environment Variables #######################


# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Specifiying the Login Item
LoginItem='/usr/bin/osascript <<EOT
try
tell application "System Events"
make login item at end with properties {path:"/Applications/ADPassMon.app"}
end tell
end try
EOT'


################## DO NOT MODIFY BELOW THIS LINE ######################


# Set the LoginItem
su - "${user}" -c "${LoginItem}"

exit 0
