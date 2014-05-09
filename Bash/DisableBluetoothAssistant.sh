#!/bin/bash

# Disable the Bluetooth Setup Assistant
echo "Disabling the Bluetooth Setup Assistant..."
if [ -d "/Library/Application Support/JAMF/DisabledApplications/" ]; then
/bin/mv '/System/Library/CoreServices/Bluetooth Setup Assistant.app' '/Library/Application Support/JAMF/DisabledApplications/'
else
/bin/mkdir -p '/Library/Application Support/JAMF/DisabledApplications/'
/bin/mv '/System/Library/CoreServices/Bluetooth Setup Assistant.app' '/Library/Application Support/JAMF/DisabledApplications/'
fi

