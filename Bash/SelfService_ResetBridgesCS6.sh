#!/bin/bash

############## HISTORY ####################
#
# http://forums.adobe.com/message/5347792
#
############################################

####### ENVIRONMENT VARIABLES ###########

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Quit Bridge CS6
app=`/usr/bin/osascript <<-EOF
tell application "System Events"
quit application  "Adobe Bridge CS6"
end tell
EOF`

######### DO NOT MODIFY BELOW THIS LINE #########

# Quit the App
$x

# Delete the preference file
su - "${user}" -c 'rm -rf ~/Library/Preferences/com.adobe.bridge5.plist'
su - "${user}" -c 'rm -rf ~/Library/Caches/Adobe/Bridge\ CS6/Adobe\ Bridge\ Plug-in\ Cache'
su - "${user}" -c 'rm -rf ~/Library/Caches/Adobe/Bridge\ CS6/Cache/'

exit 0
