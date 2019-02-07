#!/bin/bash

function AC_POWER_CHECK() {

# check if machine is running on power
while [[ $(pmset -g ps | head -1 | cut -d "'" -f 2)  != "AC Power" ]]; do

# Display the message

if [ -e /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper ]; then
        /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns -heading "ERROR" -description "You must connect the machine to ac power." -button1 "OK"

else
/usr/bin/osascript -e 'tell app "System Events" to display dialog "You need to connect the machine to AC Power to continue" buttons {"OK"} default button 1'
done

fi

done

}

AC_POWER_CHECK

exit 0

