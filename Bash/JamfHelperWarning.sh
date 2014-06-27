#!/bin/bash

MSG='ENTER
     
YOUR VALUE'

sudo /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
-windowType utility -title "WARNING" -description "$MSG" -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns -iconSize 96 -button1 "OK" -defaultButton 1




