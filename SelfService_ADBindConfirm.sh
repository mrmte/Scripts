#!/bin/bash

# Calculate the users home folder sizes
ADConfirm=`dsconfigad -show`

sudo /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
-windowType utility -title "AD Bind Confirmation" -description "$ADConfirm" -button1 "OK" \
-icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns -iconSize 96
