#!/bin/bash

#################### ENVIRONMENT VARIABLES #########################

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


command=`/usr/bin/osascript <<EOT
tell application "System Preferences"
activate
set current pane to pane id "com.apple.preference.printfax"
end tell
EOT`

################## DO NOT MODIFY BELOW THIS LINE ##################

# Run the command as the currently logged in user

sudo su "${user}" -c "${command}"

exit 0
