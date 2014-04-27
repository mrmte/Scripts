#!/bin/bash


# Current Logged in User
user=`ls -l /dev/console | cut -d " " -f4`

# Delete the Finder Prefs
su - "${user}" -c 'rm -rf ~/Library/Preferences/com.apple.finder.plist'
su - "${user}" -c 'rm -rf ~/Desktop/.DS_Store'

# Relaunch Finder
su - "${user}" -c 'defaults write ~/Library/Preferences/com.apple.finder ShowHardDrivesOnDesktop TRUE'
su - "${user}" -c 'defaults write ~/Library/Preferences/com.apple.finder ShowMountedServersOnDesktop TRUE'
su - "${user}" -c 'defaults write ~/Library/Preferences/com.apple.Finder FXPreferredViewStyle clmv'
su - "${user}" -c 'Killall Finder'
