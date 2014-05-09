#!/bin/bash

### INTRO  ####

# Date and time in Language and Text system preference pane shows as US and $. These need to be changed to UK to prevent problems

# see http://macmule.com/2011/03/02/setting-user-os-language-post-install-from-casper/

#####################################################################################

# Get the current logged in user
user=`ls -l /dev/console | cut -d " " -f4`

# Set locale as the currently logged in user
su - "${user}" -c '/usr/bin/defaults write ~/Library/Preferences/.GlobalPreferences AppleLocale "en_GB"'

# Set Country as the currently logged in user
su - "${user}" -c '/usr/bin/defaults write ~/Library/Preferences/.GlobalPreferences Country "en_GB"'

# Set the measurement units to metric as the currently logged in user
su - "${user}" -c '/usr/bin/defaults write ~/Library/Preferences/.GlobalPreferences AppleMetricUnits -bool true'
