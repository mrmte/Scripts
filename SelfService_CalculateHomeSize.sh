#!/bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Calculate the users home folder sizes
sizeU=`su - "${user}" -c 'du -shc ~/*'`

sudo /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
-windowType utility -title "Your Home Directory Sizes" -description "$sizeU" -button1 "OK" \
-icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/HomeFolderIcon.icns -iconSize 96
