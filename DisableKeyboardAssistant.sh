#!/bin/bash

# Disable the Keyboard Setup Assistant
echo "Disabling the Keyboard Setup Assistant..."
if [ -d "/Library/Application Support/JAMF/DisabledApplications/" ]; then
/bin/mv '/System/Library/CoreServices/KeyboardSetupAssistant.app' '/Library/Application Support/JAMF/DisabledApplications/'
else
/bin/mkdir -p '/Library/Application Support/JAMF/DisabledApplications/'
/bin/mv '/System/Library/CoreServices/KeyboardSetupAssistant.app' '/Library/Application Support/JAMF/DisabledApplications/'
fi

