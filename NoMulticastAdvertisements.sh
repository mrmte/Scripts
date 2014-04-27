#!/bin/bash

# Write to the Launch Daemon
defaults write /System/Library/LaunchDaemons/com.apple.mDNSResponder ProgramArguments -array "/usr/sbin/mDNSResponder" "-launchd" "-NoMulticastAdvertisements"
