#!/bin/bash

# https://jamfnation.jamfsoftware.com/discussion.html?id=9102

######## ENVIRONMENT VARIABLES ##########

# Carry out an OS version check
OS=`/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print substr($1,1,4)}'`

# Specify the identifier
Id=com.apple.systemuiserver


####### DO NOT MODIFY BELOW THIS LINE ######

# Check to see if OSis 10.9
if [[ "$OS" == "10.9" ]]; then

# Remove it from the database
sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "delete from access where client='$Id';"

# Add the App to the sqlite3 database to allow it to run
sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceAccessibility','$Id',0,1,1,NULL);"

fi

exit 0
