#!/bin/bash

# Enable Require password to wake this computer from sleep or screen saver
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -int 1
