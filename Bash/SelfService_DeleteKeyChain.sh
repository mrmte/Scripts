#!/bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Show the Desktop through Expose
/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control 1

# Display the dialog to the user
x=`/usr/bin/osascript <<EOT
tell application "Finder"
        activate
        set myReply to button returned of (display dialog "This will delete your keychain login and everything in it. YOUR MACHINE WILL THEN RESTART! Click Cancel to abort" buttons {"More Info" , "Cancel" , "Do it!"} default button "Cancel")
end tell
EOT`
echo 'Button is: '$x

if [[ $x = "More Info" ]]; then

# Open the solutions page
su - "${user}" -c 'open http://support.apple.com/kb/TS5362'

# Pause 5 seconds
sleep 5

su - "${user}" -c 'open http://support.apple.com/kb/HT1631'

# Pause 10 seconds
sleep 10

elif [[ $x = "Do it!" ]]; then
echo 'Shell script continues...'

# Delete the keychains as the currently logged in user
su - "${user}" -c 'rm -rf ~/Library/Keychains/*'

# Show the Desktop through Expose
/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control 1

# Displaying a message to tell the user it has finished
osascript -e 'tell app "System Events" to display dialog "Keychain deleted. You will need to restart your machine"'

# Pause 5 seconds
sleep 5

# Log out
shutdown -r now

else

# Displaying a message to tell the user it has finished
osascript -e 'tell app "System Events" to display dialog "Nothing Done. Aborted!"'

/usr/bin/osascript <<EOF
try
tell application "Finder"
activate
end tell
end try
EOF

fi
