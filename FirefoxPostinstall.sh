#!/bin/bash

# Removing the Firefox updater
sudo rm -rf /Applications/Firefox.app/Contents/MacOS/updater.app
sudo rm -rf /Applications/Firefox.app/Contents/MacOS/updater.ini

consoleuser=`ls -l /dev/console | cut -d " " -f4`
mobileusers=`ls /Users`

# Find the users bookmarks and copy them back
cp -R /Users/"${mobileusers}"/Documents/Firefox_bookmarkbackups/ /Users/"${users}"/Library/Application\ Support/Firefox/Profiles/********.default/

# Pause 5 seconds
sleep 5

# Correct permissions on the users ffbackup app data
chown -R "${mobileusers}" /Users/"${users}"/Library/Application\ Support/Firefox/

#Check to see if Firefox exists
if
ls -la /Applications/Firefox.app/Contents/Resources
then


# Making sure the permissions on the Info.plist are correct
chmod -R 775 /Applications/Firefox.app
fi

# Restart launch services if a user is logged in
su - "${consoleuser}" -c '/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f /Applications/Firefox.app'

# Pause 10 seconds
sleep 10

# Make sure Firefox is the default web browser using duti
su - "${consoleuser}" -c '/usr/local/bin/duti -s org.mozilla.firefox public.html'
su - "${consoleuser}" -c '/usr/local/bin/duti -s org.mozilla.firefox http'
su - "${consoleuser}" -c '/usr/local/bin/duti -s org.mozilla.firefox https'
su - "${consoleuser}" -c '/usr/local/bin/duti -s org.mozilla.firefox ftp'

exit 0
