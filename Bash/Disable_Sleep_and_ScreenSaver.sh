#!/bin/bash

#### ENVIRONMENT VARIABLES ####

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


##### DO NOT MODIFY BELOW THIS LINE #####

# unload the launch agent if it already exist
if [ -f /Library/LaunchAgents/com.caffeinate.Launchd.plist ]; then
su "${user}" -c 'launchctl unload /Library/LaunchAgents/com.caffeinate.Launchd.plist'
fi

# Check to see if the binary exists and if so create the launch agent
if [ -f /usr/bin/caffeinate ]; then

echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.caffeinate.Launchd</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/bin/caffeinate</string>
		<string>-d</string>
		<string>-i</string>
		<string>-m</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>" >/Library/LaunchAgents/com.caffeinate.Launchd.plist


# Load the launch agent
su "${user}" -c 'launchctl load /Library/LaunchAgents/com.caffeinate.Launchd.plist'
fi
