#!/bin/bash

#############################################################################
#                                                                           #
#                                                   						#
#                                                                           #
# 		                                                                    #
#                                                                           #
# This is to clean users font caches and to restart the system font system  #
#                                                                           #
#############################################################################


for user in $(ls /Users); do

# Delete the users Adobe Font Caches
rm -rf /Users/"$user"/Library/Caches/Adobe/TypeSupport

# Delete the users Acrobat Font Caches
rm -rf /Users/"$user"/Library/Caches/Acrobat

# Delete the users InDesign Cache
rm -rf /Users/"$user"/Library/Caches/Adobe\ InDesign

# Delete the users Microsoft Font Caches
rm -rf /Users/"$user"/Library/Preferences/Microsoft/Office\ 2008/Office\ Font\ Cache\ \(12\)
rm -rf /Users/"$user"/Library/Caches/com.microsoft.browserfont.cache

done

# Restarting the System Font Server

# Remove the System font database
atsutil databases -remove

# Shut the Sytem Font Server Down
atsutil server -shutdown

# Start the System Font Server
atsutil server -ping

