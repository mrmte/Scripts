#!/bin/bash

# Username and password fields instead of badges
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool "TRUE"

# Show host info
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo "DSStatus"

# Add the banner
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "The programs and data held on this system are the property of YOUR COMPANY. Any unauthorised access to the YOUR COMPANY network or resources is strictly forbidden and will lead to criminal prosecution. Access to this system will be recorded."
