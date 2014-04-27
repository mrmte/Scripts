#!/bin/bash

# Get the console user
user=`ls -l /dev/console | cut -d " " -f4`

# run command as console user
su - "${user}" -c 'defaults write com.apple.finder ShowMountedServersOnDesktop -bool true'
