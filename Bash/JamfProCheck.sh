#!/bin/bash


####################################################################################################################################
#
# INTRODUCTION
#
# This is see if the machine has an internet connection, jamf server is up, binary is missing, jamf manage errors, jamf log error.
# Then if necessary it will reinstall your hidden local quickadd pkg and auto enroll
# This script is best used as a /etc/daily.local because it will run everyday hooking on to the end of the daily periodic scripts.
# It is also best to load this as a launch daemon at startup.
#
####################################################################################################################################




##########################
#			                   #
# Clearing the variables #
#			                   #
##########################

QUICK_ADD=""
CHECKSUM=""
BINARY=""
BINARY_MISSING=""
BINARY_EXISTS=""
INTERNET=""
JAMFPRO_IS_UP=""
LOG_ERROR=""
JAMF_MANAGE_ERROR=""
VALID_MD5=""
GOOGLE=""
GET_WORD_COUNT=""
LAUNCH_DAEMON=""

##########################
# 			                 #
# Setting the variables	 # 
#			                   #
##########################

QUICK_ADD="/private/var/db/QuickAdd.pkg"
CHECKSUM="" # md5 -q "path to your QuickAdd.pkg"
LAUNCH_DAEMON="/Library/LaunchDaemons/com.sn.jamfpro.recheck.Launchd.plist"
GOOGLE="8.8.8.8"
BINARY="/usr/local/jamf/bin/jamf"
TEMP_FILE="/private/tmp/CheckJSSConnection.txt"
URL="" # https://yourjamfserver.com
DESC="Prod JamfPro"
LOGFILE="/var/log/jamfpro_check.log"
LOG_OUTPUT=""
LOG_FILE="/var/log/jamfpro_check.log"

##############################
#			     #
# SETTING THE FUNCTIONS      #
#			     #
##############################

function logger() {
    local TXT="$1"
    local LOG_TYPE="$2"
    if [ "$TXT" ]; then
    	if [ "$LOG_OUTPUT" ]; then
            LOG_OUTPUT="$LOG_OUTPUT
$TXT"
        else
            LOG_OUTPUT="$TXT"
        fi
        if [ "$LOG_TYPE" != "log_only" ]; then
            echo "$TXT"
        fi
        date "+%A %m/%d/%Y %H:%M:%S [$APP_NAME] $TXT" >> $LOG_FILE
    fi
}

######################################################
# 						                                       #
# This check to see if the Jamf binary exists or not.#
#						                                         #
######################################################

function JamfBinaryPresentCheck() {
	if [ ! -f $BINARY ]; then
            BINARY_MISSING=YES
        elif [ -f $BINARY ]; then
              BINARY_EXISTS=YES
        fi
}

####################################################################################################################################
#																                                                                                                   #
# Check to see if there is an internet connection. If no internet connection a launch daemon is set tho run this again every hour. #
# If an internet connection exists and the launchdaemon exists then it is unloaded and deleted.					                           #
#																                                                                                                   #
####################################################################################################################################

function CheckInternet() {
	nc -z $GOOGLE 443  >/dev/null 2>&1
        	online=$?
        if [ $online -eq 0 ]; then
            INTERNET="YES"
		logger "There is an internet connection"
        else
            INTERNET="NO"
		logger "There is no internet connection" 
        fi

# No internet and no launch daemon. The launch daemon is created
	if [ ! -f $LAUNCH_DAEMON ] && [[ $INTERNET = "NO" ]]; then
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>EnvironmentVariables</key>
<dict>
                <key>PATH</key>
                <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/sbin</string>
        </dict>
        <key>Label</key>
        <string>com.sn.jamfpro.recheck.Launchd</string>
        <key>ProgramArguments</key>
        <array>
                <string>/bin/bash</string>
                <string>/etc/daily.local</string>
        </array>
        <key>RunAtLoad</key>
        <false/>
        <key>StartInterval</key>
        <integer>3600</integer>
</dict>
</plist>" > $LAUNCH_DAEMON

# correct permissions on the 1 hour launch daemon
	chown root:wheel $LAUNCH_DAEMON 
	chmod 644 $LAUNCH_DAEMON

# load the 1 hour launch daemon
	launchctl load $LAUNCH_DAEMON         

# quit
	exit 1

# If internet is no just quit
	elif [[ $INTERNET = "NO" ]]; then

# quit
	exit 1

# if the 1 hour  launch daemon exists and internet is yes
	elif [ -f $LAUNCH_DAEMON ] && [[ $INTERNET = "YES" ]]; then

# unload the 1 hour launch daemon
	launchctl unload $LAUNCH_DAEMON

# remove the 1 hour launch daemon
	rm $LAUNCH_DAEMON
	
	fi

}

##############################################################################################
#											                                                                       #
# This checks to see if the jamf pro server is up and writes the result to a temporary file. #
# The temporary file is then queried to see the word count				                           #
# word count of 1 = server is up							                                               #
# word count of 1+ = server is down							                                             #
#											                                                                       #
##############################################################################################
        
function checkJSS() {
	curl -L $URL/JSSCheckConnection -o $TEMP_FILE > /dev/null 2>&1
		if [ -f $TEMP_FILE ]; then
		    GET_WORD_COUNT=$(wc -w <$TEMP_FILE)
	rm $TEMP_FILE > /dev/null 2>&1
		fi
}

######################################################################################################
#												                                                                             #
# This checks to see if there is and error when trying to do a jamf log to send the ip to the server.#
# This also check to see if there is an error when trying to a jamf manage.		                       #    
# 												                                                                           #
######################################################################################################        
	
function JamfBinaryErrorCheck() {
	if [ -f $BINARY ]; then
        
	if /usr/local/jamf/bin/jamf log | grep "error"; then
        	LOG_ERROR=YES
        fi
        
	if $BINARY manage | grep "Error"; then
        	JAMF_MANAGE_ERROR=YES
	fi
	
	fi
}

#################################################################################
# 										                                                          #
# This checks the validity of the local package by carrying out a md5 checksum. #
#										                                                            #
#################################################################################       
	
function md5Check() {
        if [ -f $QUICK_ADD ]; then
            CHECK_IT=`md5 -q $QUICK_ADD`
        if [[ $CHECK_IT = $CHECKSUM ]]; then
            VALID_MD5=YES
        fi
        fi
}

###################################################################
#								                                                  #
# Install the pkg and unload and remove the 1 hour launch daemon. #
#								                                                  #
###################################################################
	
function installpkg() {
	sudo installer -pkg $QUICK_ADD -target / -allowUntrusted > /dev/null 2>&1
		launchctl unload $LAUNCH_DAEMON > /dev/null 2>&1
	rm $LAUNCH_DAEMON > /dev/null 2>&1
	rm /private/tmp/.login > /dev/null 2>&1
}

##########################################
#					                               #
# Main script body do not modify below.  #
#					                               #
##########################################

# Check for / create logFile
if [ ! -f "${LOGFILE}" ]; then
    # logFile not found; Create logFile
    /usr/bin/touch "${LOGFILE}"
fi

# see if there is internet. If no internet access the script will exit
	CheckInternet

# check to see if the JSS is up or not
	checkJSS

# if the word count is greater than 1 jamf pro is down and the script will exit
	if [[ $GET_WORD_COUNT -gt 1 ]]; then
	     logger "$DESC DOWN!"
        exit 1

# if word count is 1 then jamf pro is up and the script will continue
	elif [[ $GET_WORD_COUNT=1 ]]; then
	       logger "$DESC UP"

# check to see if the binary is on the machine
	JamfBinaryPresentCheck


# see if jamf log & jamf manage commands come back with errors
	JamfBinaryErrorCheck

# check the validity of the local pkg
	md5Check

# re-enrolling if jamf binary is missing, there is an internet conncetion and QuickAdd is valid
	if [[ $BINARY_MISSING = "YES" ]] && [[ $INTERNET = "YES" ]] && [[ $VALID_MD5 = "YES" ]]; then
	     logger "jamf binary missing, machine has an internet connection & QuickAdd.pkg is valid. Please wait enrolling..."

# carry out the install function
	installpkg

# re-enroll if the binary exists, has and internet connection, jamf pro is up, QuickAdd is valid but jamf manage detects and error
	elif [[ $BINARY_EXISTS = "YES" ]] && [[ $JAMF_MANAGE_ERROR = "YES" ]] && [[ $GET_WORD_COUNT=1 ]] && [[ $INTERNET = "YES" ]] && [[ $VALID_MD5 = "YES" ]]; then
	       logger "jamf binary is installed but machine is Unmanaged, there is an active internet connection, Jamf Pro is available & QuickAdd.pkg is valid. Please wait enrolling..."

# carry out the install function
	installpkg

# # re-enroll if the binary exists, has and internet connection, jamf pro is up, QuickAdd is valid but jamf log detects and error
	elif [[ $BINARY_EXISTS = "YES" ]] && [[ $LOG_ERROR = "YES" ]] && [[ $GET_WORD_COUNT=1 ]] && [[ $INTERNET = "YES" ]] && [[ $VALID_MD5 = "YES" ]]; then

# carry out the  install function
	installpkg

# checks everything is ok	
elif [[ $BINARY_EXISTS = "YES" ]] && [[ $LOG_ERROR != "YES" ]] && [[ $GET_WORD_COUNT=1 ]] && [[ $INTERNET = "YES" ]] && [[ $JAMF_MANAGE_ERROR != "YES" ]]; then
	
       logger "Checks passed. Everything is working."
	
	fi
	fi
exit 0
