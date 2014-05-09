#!/bin/bash

# Current Console User
user=`ls -l /dev/console | cut -d " " -f4`

# As console user make AirDrop work over Ethernet
su - "${user}" -c 'defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true'
