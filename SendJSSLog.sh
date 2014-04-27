#!/bin/bash

##### ENVIRONMENT VARIABLES #####

# Check to see if the JSS is available and if yes, then submits the current IP
checkjss=`/usr/sbin/jamf checkJSSConnection -retry 0 | grep "The JSS is available"`


#### DO NOT MODIFY BELOW THIS LINE ####

# Send the log to the JSS
if [ "$checkjss" == "The JSS is available." ]; then
/usr/sbin/jamf log
fi

exit 0

