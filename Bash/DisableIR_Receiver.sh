#!/bin/bash

# Disable the IR Receiver
sudo /usr/bin/defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
