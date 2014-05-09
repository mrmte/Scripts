#!/bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


# Registering Microsoft Entourage with launch services registration
su - "${user}" -c '/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f /Applications/Microsoft\ Office\ 2008/Microsoft\ Entourage.app/'


# Pause 10 seconds
sleep 10


# Setting Microsoft Entourage as the default mail client
su - "${user}" -c '/usr/local/bin/duti -s com.microsoft.entourage com.microsoft.entourage.email-message'
su - "${user}" -c '/usr/local/bin/duti -s com.microsoft.entourage com.microsoft.entourage.archive'
su - "${user}" -c '/usr/local/bin/duti -s com.microsoft.entourage mailto'
su - "${user}" -c '/usr/local/bin/duti -s com.microsoft.entourage public.message'
su - "${user}" -c '/usr/local/bin/duti -s com.microsoft.entourage public.vcard'
su - "${user}" -c '/usr/local/bin/duti -s com.microsoft.entourage com.apple.ical.ics'


exit 0
