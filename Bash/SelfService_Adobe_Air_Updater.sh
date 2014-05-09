#!/bin/bash


# Display the instruction to the user
jamf displayMessage -message 'If you get asked for admin rights during the update click on cancel and run the Adobe Air Updater from the Self Service again!'

# Get the current console user
consoleuser=`ls -l /dev/console | cut -d " " -f4`

# Users Adobe Air Updater
userupdater=/Users/"${consoleuser}"/Library/Application\ Support/Adobe/AIR/Updater/Background/updater

# If the background updater exists then open in in the users location
if
ls "${userupdater}"
then
"${userupdater}" -update

# Otherwise
else

# Open the Adobe AIR Updater application
open /Library/Frameworks/Adobe\ AIR.framework/Versions/1.0/Resources/Adobe\ AIR\ Updater.app/

# Pause 2 seconds
sleep 2

# Kill Adobe AIR
kill `ps auxww | grep "Adobe AIR Installer" | awk '{print$2}'`



fi
