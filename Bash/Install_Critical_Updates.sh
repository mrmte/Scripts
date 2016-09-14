#!/bin/bash

# For OS updates use OSXUpd
# For Security updates use SecUpd

# Get any OS updates
getosupd=$(softwareupdate -l | grep OSXUpd | awk 'NR==1 {print $2}')

# Get any security updates
getsecupd=$(softwareupdate -l | grep SecUpd | awk 'NR==1 {print $2}')


### DO NOT MODIFY BELOW THIS LINE ###

if  [[ $getsecupd = "No new software available." ]] && [[ $getosupd = "No new software available." ]]; then

echo "no os or security updates to apply"

exit 1

else

# Install OS updates
softwareupdate -i $getosupd

# Install Security updates
softwareupdate -i $getsecupd

fi
