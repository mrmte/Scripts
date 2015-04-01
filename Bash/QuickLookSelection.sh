#!/bin/bash

# Get the current user
user=`ls -l /dev/console | cut -d " " -f4`

# Make quick look better by making text selectable
su - "${user}" -c 'defaults write com.apple.finder QLEnableTextSelection -bool TRUE'

# Add to the new user template
#sudo defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.finder QLEnableTextSelection -bool true


# Relaunch the finder
'killall Finder'
