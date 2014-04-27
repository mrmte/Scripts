#!/bin/bash

user=`ls -l /dev/console | cut -d " " -f4`

# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1

# Displaying a message to tell the user to wait

x=`/usr/bin/osascript <<EOT
tell application "Finder"
        activate
        set myReply to button returned of (display dialog "Please wait for the script to do its stuff and wait for confirmation! When the restore is complete, select Don't import anything, click Continue and within Firefox click Bookmarks > Show All Bookmarks > Click star symbol > Restore > browse to the backup" buttons {"Cancel" , "Do it!"} default button "Cancel")
end tell
EOT`
echo 'Button is: '$x
if [[ $x = "Do it!" ]]; then
echo 'Shell script continues...'

#osascript -e 'tell app "System Events" to display dialog "Please wait for the script to do its stuff and wait for confirmation!" buttons {"Cancel" , "Do it!"} default button "Cancel"'

# quitting Firefox
killall -9 firefox-bin
killall -9 firefox

# Removing previous Firefox_bookmarkbackups as the currently logged in user
su - "${user}" -c 'rm -rf ~/Documents/Firefox_bookmarkbackups'

# Pausing 3 seconds
sleep 3

# Making a backup directory as the currently logged in user
su - "${user}" -c 'mkdir ~/Documents/Firefox_bookmarkbackups'

# Making a temp directory as the currently logged in user
su - "${user}" -c 'mkdir ~/Temp'

# Pausing 3 seconds
sleep 3

# Find the users bookmarkbackups and move them to the temp directory as the currently logged in user
su - "${user}" -c 'Find -x ~/Library/Application\ Support/Firefox/Profiles/********.default/ -name 'bookmarkbackups' -print0 | xargs -0 -I bookmarkbackups cp -R bookmarkbackups ~/Temp/'

# Pausing 3 seconds
sleep 3

# Copy the bookmarkbackups to the Firefox_bookmarkbackups directory as the currently logged in user
su - "${user}" -c 'cp -R ~/Temp/bookmarkbackups ~/Documents/Firefox_bookmarkbackups/'

# Pausing 5 seconds
sleep 5

# Deleting the FireFox app data as the currently logged in user
su - "${user}" -c 'rm -rf ~/Library/Application\ Support/Firefox'

# Removing the users Firefox cache as the currently logged in user
su - "${user}" -c 'rm -rf ~/Library/Caches/Firefox'

# Pausing 5 seconds
sleep 5

# Launch Firefox as the currently logged in user 
su - "${user}" -c 'open /Applications/Firefox.app'

# Pausing 10 seconds
sleep 10

# Moving the bookmarkbackups from the temp to the users new app data location as the currently logged in user
su - "${user}" -c 'Find -x ~/Library/Application\ Support/Firefox/Profiles/ -name '********.default' -print0 | xargs -0 -I folder mv ~/Temp/bookmarkbackups/ folder'

# Pausing 3 seconds
sleep 3

# Removing the Temp directory as the currently logged in user
su - "${user}" -c 'rm -rf ~/Temp'

# Launch Firefox as the currently logged in user
su - "${user}" -c 'open http://kb.mozillazine.org/Lost_bookmarks#Restoring_bookmarks_in_Firefox_3_and_above /Applications/Firefox.app'

# Show the Desktop through Expose
/Applications/Utilities/Expose.app/Contents/MacOS/Expose 1

# Display dialog to tell the user to look at the Restoring bookmark backups section
osascript -e 'tell app "System Events" to display dialog "Restore Complete. Click Bookmarks > Show All Bookmarks > Click star symbol > Restore > browse to the backup"'
fi
