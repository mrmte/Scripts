#!bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

DATE=`date "+%d-%m-%y_%H.%M"`

# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1

# Display the dialog to the user
x=`/usr/bin/osascript <<EOT
tell application "Finder"
        activate
        set myReply to button returned of (display dialog "This will export the Entourage Notes to your desktop as an rge format. When this is running DO NOT USE ENTOURAGE! Click Cancel to stop and save unsent emails as drafts and then run this again" buttons {"Cancel" , "Do it!"} default button "Cancel")
end tell
EOT`
echo 'Button is: '$x

if [[ $x = "Do it!" ]]; then
echo 'Shell script continues...'

# Export the Entourage 2008 Notes
su - "${user}" -c '/usr/bin/osascript <<-EOF

on run
	tell application "Microsoft Entourage"
		export archive to "/Users/Shared/Notes.rge" item types {note items}
	end tell
	
end run

EOF'

# Pause 30 secnds
sleep 30

# Rename the exported file to include the date and time
mv /Users/Shared/Notes.rge  /Users/Shared/Notes_"${DATE}".rge

# Pause 5 seconds
sleep 5

# Move the rge file to the users desktop as the currently logged in user
su - "${user}" -c 'cp -r /Users/Shared/*.rge ~/Desktop/'

# Pause 5 seconds
sleep 5

# remove the rge file in the shared directory
rm -rf /Users/Shared/*.rge

# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1

# Displaying a message to tell the user it has finished
osascript -e 'tell app "System Events" to display dialog "You will find the Notes  rge export file on your desktop"'

fi





