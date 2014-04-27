#!/bin/sh

for disk in $(diskutil list | awk '/disk[1-9]s/{ print $NF }' | grep -v /dev); do
if [[ $(diskutil info $disk | awk '/Protocol/{ print $2 }') == "USB" ]]; then
echo "Device $disk is a USB removable disk"
diskName=$(diskutil info $disk | awk -F"/" '/Mount Point/{ print $NF }')
MSG="There is a USB disk named \"$diskName\" still connected to this computer.

Please remember to take it with you!"
sudo /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
-windowType utility -title "USB device still attached" -description "$MSG" -button1 "OK" \
-icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns -iconSize 96
fi
done
