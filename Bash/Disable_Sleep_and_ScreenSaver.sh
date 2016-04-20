#!/bin/bash

#### ENVIRONMENT VARIABLES ####

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


##### DO NOT MODIFY BELOW THIS LINE #####

# unload if it already exist
if [ -f /Library/LaunchDaemons/com.sn.caffeinate.Launchd.plist ]; then
launchctl unload /Library/LaunchDaemons/com.sn.caffeinate.Launchd.plist
fi

# Check to see if the binary exists and if so create the launch agent
if [ -f /usr/bin/caffeinate ]; then

echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>com.sn.caffeinate.Launchd</string>
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
</plist>" >/Library/LaunchDaemons/com.sn.caffeinate.Launchd.plist
chown root:wheel /Library/LaunchDaemons/com.sn.caffeinate.Launchd.plist
chmod 644 /Library/LaunchDaemons/com.sn.caffeinate.Launchd.plist

sleep 3

# Load the launch agent
launchctl load /Library/LaunchDaemons/com.sn.caffeinate.Launchd.plist
fi
