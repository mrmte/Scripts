#!/usr/bin/env zsh

# inspired by https://snelson.us/2024/10/apple-intelligence-extension-attribute/


autoload is-at-least
LOGGED_IN_USER=$(stat -f '%Su' /dev/console)
HOME_DIR=$(dscl /Local/Default read "/Users/$LOGGED_IN_USER" NFSHomeDirectory | sed 's/NFSHomeDirectory://' | xargs)
RESULT="Apple Intelligence for Siri: Not Configured"
osVersion=$( sw_vers -productVersion )
if is-at-least 15.1 $osVersion; then
    lastUser=$( defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName )
    testFile="$HOME_DIR/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist"
    if [[ -e "${testFile}" ]] ; then
        echo "$testFile exists"
        mobileMeAccountID=$( /usr/libexec/PlistBuddy -c "print Accounts:0:AccountDSID" "/Users/$lastUser/Library/Preferences/MobileMeAccounts.plist" 2>/dev/null )
        if [[ "${mobileMeAccountID}" == *"File Doesn't Exist"* ]]; then
                echo "Mobile Me Account ID does not exist"
                RESULT="Mobile Me Account ID does not exist. Apple ID Not Signed In"
        else       
            value=$( /usr/bin/defaults read "$HOME_DIR/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist" "$mobileMeAccountID" 2>/dev/null )
            if [[ "${value}" == "1" ]]; then
                echo "Apple Intelligence for Siri: Enabled"
                RESULT="Apple Intelligence for Siri: Enabled"
                killall "System Settings" 2>/dev/null
                sleep 1
                su ${LOGGED_IN_USER} -l -c "/usr/bin/defaults write ~/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist "$mobileMeAccountID" 0"
                sleep 1
                value=$( /usr/bin/defaults read "$HOME_DIR/Library/Preferences/com.apple.CloudSubscriptionFeatures.optIn.plist" "$mobileMeAccountID" 2>/dev/null )
                if [[ "${value}" == "1" ]]; then
                    echo "Remediation failed"
                    RESULT="Apple Intelligence for Siri: Enabled"
                else
                    echo "Remediation was successful"
                    RESULT="Apple Intelligence for Siri: Disabled"
                fi  
            elif  [[ "${value}" == "0" ]]; then
                RESULT="Apple Intelligence for Siri: Disabled"
            fi
        fi
    fi
else
    RESULT="Apple Intelligence for Siri: Not Applicable; macOS ${osVersion}"
fi
/bin/echo "$RESULT"
exit 0