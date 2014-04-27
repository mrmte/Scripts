#!/bin/bash

####### ENVIRONMENT VARIABLES ##########
# Get current user
CurrentUser=`ls -l /dev/console | cut -d " " -f4`

####### DO NOT MODIFY BELOW THIS LINE #######

# Check to see if the printer is installed first before trying to make it a default

if

lpstat -p | grep "YOUR PRINTER" | awk '{print $2}'

then

su - "${CurrentUser}" -c 'lpoptions -d YOUR PRINTER'

fi

exit 0
