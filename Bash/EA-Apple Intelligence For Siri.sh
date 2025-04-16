#!/usr/bin/env zsh
##################################################################################
# A script to collect the status of Apple Intelligence for macOS 15 (and later). #
#                                                                                #
# Possible results:                                                              #
#   • Pre-macOS 15.1                                                             #
#       • Not Applicable; macOS ${osVersion}                                     #
#   • macOS 15.1 (and later)                                                     #
#       • Not Configured                                                         #
#       • Enabled (no Apple Account)                                             #
#       • Apple Account Enabled                                                  #
#                                                                                #
# Inspired by:                                                                   #
# https://boberito.medium.com/raising-your-iq-on-apple-intelligence-380933894340 #
##################################################################################
autoload is-at-least
RESULT="Apple Intelligence for Siri: Not Configured"
osVersion=$( sw_vers -productVersion )
if is-at-least 15.1 $osVersion; then
    lastUser=$( defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName )
    testFile="/Users/${lastUser}/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist"
    if [[ -f "${testFile}" ]] ; then
        mobileMeAccountID=$( /usr/libexec/PlistBuddy -c "print Accounts:0:AccountDSID" "/Users/$lastUser/Library/Preferences/MobileMeAccounts.plist" 2>/dev/null )
        if [[ "${mobileMeAccountID}" == *"File Doesn't Exist"* ]]; then
            value=$( /usr/bin/defaults read "/Users/$lastUser/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist" device 2>/dev/null )
            if [[ "${value}" == "1" ]]; then
                RESULT="Apple Intelligence for Siri: Enabled"
            else
                RESULT="Apple Intelligence for Siri: Disabled"
            fi
        else
        
            value=$( /usr/bin/defaults read "/Users/$lastUser/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist" "$mobileMeAccountID" 2>/dev/null )
            if [[ "${value}" == "1" ]]; then
                RESULT="Apple Intelligence for Siri: Enabled"
            else
                RESULT="Apple Intelligence for Siri: Disabled"
            fi
        fi
    fi
else
    RESULT="Apple Intelligence for Siri: Not Applicable; macOS ${osVersion}"
fi
/bin/echo "<result>$RESULT</result>"