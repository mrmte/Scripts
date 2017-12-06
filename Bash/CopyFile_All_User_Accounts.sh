#!/bin/bash

# This is used to copy a file to all real user accounts on a machine to a particular location and set the owner of the file correctly.


# GET ALL THE REAL ACCOUNTS ON THE MACHINE
userName=$(dscl . list /Users | grep -v "^_" | grep -v "^root" | grep -v "^daemon" | grep -v "^nobody" | grep -v "^Guest" | grep -v "^com.apple.calendarserver")

# FILE TO COPY
fileLocationSource="XXX"
file="XXX"

#
for GET_USERS in $userName ;do
home=$(dscl . read /Users/$GET_USERS NFSHomeDirectory | awk '{print $2}')

if [ -e $fileLocationSource$file ]; then
        cp $fileLocationSource$file $home/
        chown $GET_USERS $home/$file
fi
done

exit 0
