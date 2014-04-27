#!/bin/bash

######################### HISTORY #####################################
#                                                                     #
# Created by Tim Kimpton 14/05/2013                                   #
#                                                                     #
# Set an application to open at login as the currently logged in user #
#                                                                     #
################### Environment Variables #############################

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Specifiying the Login Item
LoginItem='/usr/bin/osascript <<EOT
try
tell application "System Events"
make login item at end with properties {path:"/Library/PreferencePanes/GeekTool.prefPane/Contents/Resources/GeekTool.app/"}
end tell
end try
EOT'

############### DO NOT MODIFY BELOW THIS LINE ################

# Set the App as a login item as the currently logged in user
su - "${user}" -c "${LoginItem}"


