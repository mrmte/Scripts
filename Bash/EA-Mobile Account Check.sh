#!/bin/bash

# This is to see if the logged in user is a managed mobile account

LOGGEDINUSER=""
MOBILE_USER_CHECK=""

LOGGEDINUSER=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
MOBILE_USER_CHECK=$(/usr/bin/dscl . -read /Users/"$LOGGEDINUSER" AuthenticationAuthority | head -2 | awk -F'/' '{print $1}' | tr -d '\n' | sed 's/^[^:]*: //' | sed s/\;//g)


if [[ "$MOBILE_USER_CHECK" = "LocalCachedUser" ]]; then
echo "<result>"$LOGGEDINUSER is a mobile account"</result>"
else
echo "<result>"$LOGGEDINUSER is not a mobile account"</result>"
fi

exit 0
