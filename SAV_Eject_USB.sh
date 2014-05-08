#!/bin/bash

######################################## HISTORY ###########################################################
#                                                                                                          #
# By Tim Kimpton                                                                                           #
#                                                                                                          #
# 21/2/2013                                                                                                #
#                                                                                                          #
# Version 1.1                                                                                              #
#                                                                                                          #
# To be used in conjunction with a launch daemon to run all the time 					   #
#                                                                                                          #
# If a SAV Threat is detected in the SAV log then the external device is ejected                           #
#                                                                                                          #
############################################################################################################

######################################## VARIABLES #########################################################

# Get the Volume name from the SAV log
diskName=`grep "Threat" /Library/Logs/Sophos\ Anti-Virus.log | grep "Volumes" | cut -d"/" -f3`

# Get the disk identifier
identifier=`diskutil list | grep "${diskName}" | awk '{print $NF}'`

################################# DO NOT MODIFY BELOW THIS LINE #############################################

# Check to see if Threat exists
if grep "Threat" /Library/Logs/Sophos\ Anti-Virus.log ;then

# Eject the volume
hdiutil eject -force "${identifier}"

# Remove the SAV log
rm -rf /Library/Logs/Sophos\ Anti-Virus.log

# Update SAV to receate the log
/usr/bin/sophosupdate

fi
exit 0
