#!/bin/bash

# This is designed to carry out critical updates first being 
# 1. Security Updates
# 2. OS Updates
# 3. Everything else

function SecurityUpdates() {
# Get any security updates
getsecupd=$(softwareupdate -l | grep "* Security Update" | cut -d '*' -f2 | sed -e 's/^[ \t]*//')

if  [[ $getsecupd = "No new software available." ]]; then
echo "No Security Updates are available"
else
softwareupdate -i $getsecupd
fi
}

function OSUpdates() {

getosupd=$(softwareupdate -l | grep "* macOS Update" | cut -d '*' -f2 | sed -e 's/^[ \t]*//')
if [[ $getosupd = "No new software available." ]]; then
echo "No OS Updates are available"
else
softwareupdate -i $getosupd
fi
}

# critical updates first
function SecurityUpdates
function OSUpdates

# carry out a full sofware update
softwareupdate -i -a
exit 0
