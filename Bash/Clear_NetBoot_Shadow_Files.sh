#!/bin/bash

### INTRODUCTION ###

# This is used to clear the netboot shadow files and restart the service. I recommend this to be done out of hours via a launchdaemon at 1am.

### ENVIRONMENT VARIABLES ###

files=$(ls /Library/NetBoot/NetBootClients0/* 2> /dev/null | wc -l)

### DO NOT MODIFY BELOW THIS LINE ###

if [ "$files" != "0" ]; then
echo "clearing NetBoot Clients folder"

# Stop the netboot service
serveradmin stop netboot

# Rmove the netboot shadow files
rm -rf /Library/NetBoot/NetBootClients0/*

# Start the netboot service
serveradmin start netboot
fi

exit 0
