#!/bin/bash

########### EVIRONMENT VARIABLES ############

# Get current user
CurrentUser=`ls -l /dev/console | cut -d " " -f4`

# Commad to run
cmd='defaults write ~/Library/Preferences/.GlobalPreferences AppleMiniaturizeOnDoubleClick -bool true'

########### DO NOT MODIFY BELOW THIS LINE ############

# Run the command
su - "${CurrentUser}" -c "$cmd"


