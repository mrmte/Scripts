#!/bin/bash

# Get the current logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Display the dialog to the user
x=`/usr/bin/osascript <<EOT
tell application "Finder"
        activate
        set myReply to button returned of (display dialog "Entourage will need to close! click Cancel to save any drafts and then you need to run this again or click Do it! to continue and wait for confirmation!"  buttons {"Cancel" , "Do it!"} default button "Cancel")
end tell
EOT`
echo 'Button is: '$x
if [[ $x = "Do it!" ]]; then
echo 'Shell script continues...'


# Quit Entourage
killall Microsoft\ Entourage

# Kill the Microsoft Database Daemon
killall Microsoft\ Database\ Daemon

# Make sure Indexing is Enabled
mdutil -a -i on /

# Pause 3 seconds
sleep 3

# Unload the launch daemon
launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist 

# Load the launch daemon
launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist 

# Pause 20 seconds
sleep 20

# Import the Spotlight search into Entourage
su - "${user}" -c 'arch -i386 mdimport ~/Library/Caches/Metadata/Microsoft/Entourage/2008/'

# Open Entourage
su - "${user}" -c 'open /Applications/Microsoft\ Office\ 2008/Microsoft\ Entourage.app'


# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1


# Displaying a message to tell the user to wait
osascript -e 'tell app "System Events" to display dialog "Entourage Spotlight should be fixed now!"'

fi
