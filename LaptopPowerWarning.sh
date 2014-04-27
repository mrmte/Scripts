#!/bin/bash
#------VARIABLES-------

desiredPercentage="80"

# Check the status of the battery to see if changed since entering the loop
battStatus=$(pmset -g batt | awk '/charging|discharging|charged/ {print $3}' | cut -d";" -f1)
			
# Check battery percentage and store it in a variable
currentPercentage=$(pmset -g batt | grep -o "[0-9]\+%;" | cut -d"%" -f1)

MSG="Your battery is at $currentPercentage% 

For proper maintenance of a lithium-based battery, it’s important to keep the electrons in
it moving occasionally. 

Apple does not recommend leaving your portable plugged in all the
time. 

An ideal use would be a commuter who uses her notebook on the train, then plugs it
in at the office to charge. This keeps the battery juices flowing. 

Apple recommends charging and discharging its battery at least once per month

Please unplug the power cord and run off the battery for a bit.


               Thank you
    
http://www.apple.com/batteries/notebooks.html"

#--------- DO NOT MODIFY BELOW THIS LINE -------------#


			# If the current battery is greater than or equal to the desired percentage, then
			if [ "$currentPercentage" -ge "$desiredPercentage" ];then
			
				# Let the user know
				# Or run some other commands
				# say "Unplug me before you leave."

# Display the message with a 5 minute timeout
sudo /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
-windowType utility -title "Monthly Battery Power Reminder" -description "$MSG" -timeout 300 -button1 "OK"  \
-icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns -iconSize 96 
			
fi 




