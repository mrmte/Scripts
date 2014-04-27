#!/bin/bash

consoleuser=`ls -l /dev/console | cut -d " " -f4`
mobileusers=`ls /Users`

# Remove the users previous Firefox bookmarkbackups
rm -rf /Users/"${mobileusers}"/Documents/Firefox_bookmarkbackups

# Sleep 3 seconds
sleep 3

# Making the bookmarkbackup folder
mkdir /Users/"${mobileusers}"/Documents/Firefox_bookmarkbackups

# Making the Temp Directory
mkdir /Users/"${mobileusers}"/Temp

# Sleep 3 seconds
sleep 3

# Copy the bookmark backups
cp -R /Users/"${mobileusers}"/Library/Application\ Support/Firefox/Profiles/********.default/bookmarkbackups /Users/"${mobileusers}"/Temp/

# Sleep 3 seconds
sleep 3

# Copy the bookmark backups
cp -R /Users/"${mobileusers}"/Temp/bookmarkbackups /Users/"${mobileusers}"/Documents/Firefox_bookmarkbackups/

# Sleep 3 seconds
sleep 3

# Removing the Temp directory as the currently logged in user
rm -rf /Users/"${mobileusers}"/Temp

# Correcting permissions on the /Users/"${mobileusers}"/Documents/Firefox_bookmarkbackups/
chown -R "${mobileusers}" /Users/"${mobileusers}"/Documents/Firefox_bookmarkbackups/

# Quit Firefox
sudo killall -9 firefox
sudo killall -9 firefox-bin

# Make sure Safari the default web browser for a moment using duti
su - "${consoleuser}" -c '/usr/local/bin/duti -s com.apple.Safari public.html'
su - "${consoleuser}" -c '/usr/local/bin/duti -s com.apple.Safari http'
su - "${consoleuser}" -c '/usr/local/bin/duti -s com.apple.Safari https'
su - "${consoleuser}" -c '/usr/local/bin/duti -s com.apple.Safari ftp'
# Restart launch services unregistering Firefox if a user is logged in

su - "${consoleuser}" -c '/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -u /Applications/Firefox.app'

# Pause 10 seconds
sleep 10

# Delete Firefox
sudo rm -rf /Applications/Firefox.app

exit 0
