#!/bin/bash

# Disable the Memory slot Utility
mkdir /Library/Application\ Support/JAMF/DisabledApplications/
sleep 3
mv /System/Library/CoreServices/Memory\ Slot\ Utility.app /Library/Application\ Support/JAMF/DisabledApplications/Memory\ Slot\ U
tility.app/

