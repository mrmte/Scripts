#!/bin/bash

# For OS updates use OSXUpd
# For Security updates use SecUpd

# Get any OS updates
getosupd=$(softwareupdate -l | grep OSXUpd | awk 'NR==1 {print $2}')

# Get any security updates
getsecupd=$(softwareupdate -l | grep SecUpd | awk 'NR==1 {print $2}')

# Install OS updates
softwareupdate -i $getosupd

# Install Security updates
softwareupdate -i $getsecupd
