#!/bin/bash

### INTRO ###

# This is used to be installed on a server running netboot services.

# The purpose of this script is to clear left over netboot client shadow files

# After a while if these build up then netbooting may stop working correctly.

# The best mechanism is to automate to run this out of hours with a launch daemon late at night

# A good tool to create the launch daemon is ligon http://mac.majorgeeks.com/files/details/lingon_freeware.html


### ENVIRONMENT VARIABLES ###

files=$(ls /Library/NetBoot/NetBootClients0/* 2> /dev/null | wc -l)

### DO NOT MODIFY BELOW THIS LINE ###

if [ "$files" != "0" ]; then
echo "clearing NetBoot Clients folder"
rm -rf /Library/NetBoot/NetBootClients0/*
fi

exit 0
