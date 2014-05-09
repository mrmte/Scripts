#!/bin/bash

# https://jamfnation.jamfsoftware.com/discussion.html?id=5012


# Set the Appstore to only show the Updates, other fields will be greyed out
defaults write /Library/Preferences/com.apple.appstore restrict-store-softwareupdate-only -bool yes

# Set updates to be allowed to be installed by writing to the database
sudo security authorizationdb write com.apple.SoftwareUpdate.scan allow
sudo security authorizationdb write system.install.apple-software allow
