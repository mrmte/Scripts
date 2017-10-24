#!/bin/bash

# This is designed to use with Bitbar https://getbitbar.com/
# This will allow you to see the status every 60 seconds on your mac :)

# Clearing variables
INTERNET=""
GOOGLE=""
TEMPFILE=""
URL=""

### SET VARIABLES
GOOGLE="8.8.8.8"
TEMPFILE=/private/tmp/CheckJSSConnection.txt
URL="https://yourserver.jamfcloud.com" # customize this
DESC="PJamfPro"


  
# Try and ping Google
function CheckInternet() {
        if ping -c 1 $GOOGLE >> /dev/null 2>&1; then
        INTERNET="YES"
        else
        INTERNET="NO"
        fi

}



# Carryout CheckJSSConnection
	function checkJSS() {
	curl -L $URL/JSSCheckConnection -o $TEMPFILE > /dev/null 2>&1
}



# see if there is internet
CheckInternet

	if [[ $INTERNET != "YES" ]]; then
echo "No Internet!"
	exit 1

else

# carryout function
checkJSS

# count the words then delete the file
getWordCount=$(wc -w <$TEMPFILE)
rm $TEMPFILE > /dev/null 2>&1

# if the word count is greater than 1 the it is down!
if [[ $getWordCount -gt 1 ]]; then
echo "$DESC DOWN!"
        exit 1

# if word count is 1 then it is up
elif [[ $getWordCount=1 ]]; then
echo "$DESC UP"
        fi
        fi

exit 0
