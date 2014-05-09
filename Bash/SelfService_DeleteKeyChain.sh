#!/bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1

# Display the dialog to the user
x=`/usr/bin/osascript <<EOT
tell application "Finder"
        activate
        set myReply to button returned of (display dialog "This will delete your keychain login and everything in it. You will then need to log off and log in again! Click Cancel to save you work and then you need to run this again or click Do it! to continue and wait for confirmation!" buttons {"More Info" , "Cancel" , "Do it!"} default button "Cancel")
end tell
EOT`
echo 'Button is: '$x

if [[ $x = "More Info" ]]; then

# Open the solutions page
su - "${user}" -c 'open -a /Applications/Firefox.app http://servicedesk/SolutionsHome.do'

# Pause 10 seconds
sleep 10


# Opening the solution as the user
su - "${user}" -c 'open -a /Applications/Firefox.app http://servicedesk/AddSolution.do?solID=17'

else

if [[ $x = "Do it!" ]]; then
echo 'Shell script continues...'

# Delete the login.keychain as the currently logged in user
su - "${user}" -c 'rm -rf ~/Library/Keychains/login.keychain'

# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1

# Displaying a message to tell the user it has finished
osascript -e 'tell app "System Events" to display dialog "Keychain deleted. You will need to log out and log in again!"'

# Pause 5 seconds
sleep 5

# Log out
/usr/bin/osascript <<-EOF

tell application "System Events"
log out
end tell

EOF

fi
fi
