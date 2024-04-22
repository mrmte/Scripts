#!/bin/bash

:<<DOC
 Author:	https://github.com/itjimbo
 Modified: Tim Kimpton

 Notes:	This script is based on scripts provided by user Pico (https://github.com/PicoMitchell) on the Mac Admins Slack channel and also from here
 https://github.com/itjimbo/macOS-Screen-Saver-and-Wallpaper/blob/main/Set%20Screen%20Saver%20and%20Keep%20User's%20Wallpaper.sh

 Improvements:
 1. Can be used below macOS Sonoma. Tested on macOS Ventura and Sonoma
 1. waits for a logged in user
 2. is designed to run as a policy in jamf pro, once per user per computer
 3. if the policy log is flushed by accident and this script runs again, then a plist is checked in the users preferences to see if it has 
 	 already run and exits silently

 Usage:
 1. create the screensaver in /Library/Screen Savers/*.saver
 2. create a pkg with the .saver and deploy via jamf policy
 3. create an EA in Jamf pro to capture the screen saver for smart group scoping
 4. create a policy in jamf to run at start up and re-occuring check-in once per user per computer scoped to the smart group

Example variables in the policy
$4 - PathToScreenSaver="/Library/Screen Savers/Corporate ScreenSaver.saver"
$5 - ScreenSaveModuleName="Corporate ScreenSaver"
$6 - PlistName="com.corp.screensaver"
$7 - Get the base64 after it has been set as follows and put in $7 of the policy in Jamf Pro (plutil -extract AllSpacesAndDisplays xml1 -o - "/Users/${loggedInUser}/Library/Application Support/com.apple.wallpaper/Store/Index.plist" | awk '/<data>/,/<\/data>/' | xargs | tr -d " " | tr "<" "\n" | tail -2 | head -1 | cut -c6)
DOC

### Variables ###
loggedInUser=$(/usr/bin/stat -f%Su /dev/console)
loggedInUserHome=$(dscl . read /Users/"$loggedInUser" NFSHomeDirectory | awk '{print $2}')
screenSaverBase64=`printf "'$7'"`
PathToScreenSaver="$4"
ScreenSaveModuleName="$5"
PlistName="$6"
screenSaverBase64=`printf "'$7'"`


### Functions ####

# This is to wait for an active user
function waitForLoggedInUser() {
	local KEEP_LOOPING="true"
	local SLEEP_TIME=30
	local IDLE_TIME=0
	local CONSOLE_USER=""
	TRY=1
while [ "$KEEP_LOOPING" = "true" ]; do
		(( TRY++ ))
		CONSOLE_USER=`ls -l /dev/console | cut -d " " -f4 | grep -v "^_" | grep -iwv "daemon" | grep -iwv "^nobody" | grep -iwv "^root" | grep -iwv "mbsetup"`
		if [ "$CONSOLE_USER" ]; then
			echo "$(date) $CONSOLE_USER is logged in"
			KEEP_LOOPING="false"
		else
			echo "$(date) No logged in user, waiting $SLEEP_TIME seconds"
			sleep $SLEEP_TIME
			if (( TRY >= 2400)); then
 				echo "$(date) Aborting after 2 hours (7200 seconds)"
 				break
 				exit 0
 			fi
		fi
	done
	return 0
	}

function getDefinedVariables() {
	# Insert desired macOS minimum version for script to run. Default is 14 for macOS 14 Sonoma and later.
	desiredmacOSVersion='14'
	
	# Do not edit beyond this point...
	getStarterVariables
}

function getStarterVariables() {
	# Do not edit these variables.
	echo "$(date) - Script by default is looking for macOS version ${desiredmacOSVersion} or later by default (macOS ${desiredmacOSVersion} - Present)."
	echo "$(date) - screenSaverBase64: ${screenSaverBase64}"
	currentRFC3339UTCDate="$(date -u '+%FT%TZ')"
	echo "$(date) - currentRFC3339UTCDate: ${currentRFC3339UTCDate}"
	loggedInUser=$(/usr/bin/stat -f%Su /dev/console)
	echo "$(date) - Logged in user: ${loggedInUser}"
	loggedInUserHome=$(dscl . read /Users/"$loggedInUser" NFSHomeDirectory | awk '{print $2}')
	echo "$(date) - Logged in users home dir: ${loggedInUserHome}"
    macOSFullProductVersion=$(sw_vers -productVersion)
	echo "$(date) - macOS Full Product Version: ${macOSFullProductVersion}"
	macOSMainProductVersion="${macOSFullProductVersion:0:2}"
	echo "$(date) - macOS Main Product Version: ${macOSMainProductVersion}"
	wallpaperStoreDirectory="/Users/${loggedInUser}/Library/Application Support/com.apple.wallpaper/Store"
	echo "$(date) - wallpaperStoreDirectory: ${wallpaperStoreDirectory}"
	wallpaperStoreFile="Index.plist"
	echo "$(date) - wallpaperStoreFile: ${wallpaperStoreFile}"
	wallpaperStoreFullPath="${wallpaperStoreDirectory}/${wallpaperStoreFile}"
	echo "$(date) - wallpaperStoreFullPath: ${wallpaperStoreFullPath}"
	wallpaperBase64=$(plutil -extract AllSpacesAndDisplays xml1 -o - "${wallpaperStoreFullPath}" | awk '/<data>/,/<\/data>/' | xargs | tr -d " " | tr "<" "\n" | head -2 | tail -1 | cut -c6-)
	echo "$(date) - wallpaperBase64: ${wallpaperBase64}"
	wallpaperLocation=$(plutil -extract AllSpacesAndDisplays xml1 -o - "${wallpaperStoreFullPath}" | grep -A 2 "relative" | head -2 | tail -1 | xargs | cut -c9- | rev | cut -c10- | rev)
	echo "$(date) - wallpaperLocation: ${wallpaperLocation}"
	wallpaperProvider=$(plutil -extract AllSpacesAndDisplays xml1 -o - "${wallpaperStoreFullPath}" | grep -A 2 "Provider" | head -2 | tail -1 | xargs | cut -c9- | rev | cut -c10- | rev)
	echo "$(date) - wallpaperProvider: ${wallpaperProvider}"
	checkmacOSVersion
}

function checkmacOSVersion() {
	echo "$(date) - Checking macOS version..."
    if [[ "${macOSMainProductVersion}" == "" ]]; then
        echo "$(date) - Could not determine macOSMainProductVersion variable."
        exitCode='1'
		finalize
    elif [[ "${macOSMainProductVersion}" -ge "${desiredmacOSVersion}" ]]; then
        checkUser
    else
        echo "$(date) - macOS is on version $macOSFullProductVersion; running legacy settings to set the screensaver"
	rm $loggedInUserHome/Library/Preferences/ByHost/com.apple.ScreenSaverPhotoChooser*.plist > /dev/null 2>&1
	rm $loggedInUserHome/Library/Preferences/ByHost/com.apple.ScreenSaver.iLifeSlideShows*.plist > /dev/null 2>&1
	sleep 1
	su "$loggedInUser" -l -c "defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName '${ScreenSaveModuleName}' path '${PathToScreenSaver}' type 0"
        killall cfprefsd
        exitCode='0'
		finalize
    fi
}


function checkUserSettingsPlist() {
if [ -e "$loggedInUserHome"/Library/Preferences/"$PlistName".plist ]; then
	UserSettingsPlist=$(defaults read "$loggedInUserHome"/Library/Preferences/$PlistName SetCorpScreenSaver)
    	if [ "$UserSettingsPlist" == "1" ]; then
        	echo "$(date) The ScreenSaver has already run for $loggedInUser"
            exit 0
         fi
 else
 	echo "Cannot find the user settings plist, continuing..."
 fi
}

function checkUser() {
	echo "$(date) - Checking valid user..."
	if [[ "${loggedInUser}" == "root" ]]; then
		echo "$(date) - Script should not be run as root user."
		exitCode='1'
		finalize
	elif [[ "${loggedInUser}" == "" ]]; then
		echo "$(date) - User cannot be defined."
		exitCode='1'
		finalize
	else
		setScreenSaverSettings
	fi
}

function setScreenSaverSettings() {
	echo "$(date) - Setting screen saver settings..."
	if [[ "${wallpaperLocation}" == "" ]]; then
		# Index.plist contents.
		aerialDesktopAndScreenSaverSettingsPlist="$(plutil -create xml1 - |
			plutil -insert 'Desktop' -dictionary -o - - |
			plutil -insert 'Desktop.Content' -dictionary -o - - |
			plutil -insert 'Desktop.Content.Choices' -array -o - - |
			plutil -insert 'Desktop.Content.Choices' -dictionary -append -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Configuration' -data "${wallpaperBase64}" -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Files' -array -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Provider' -string "${wallpaperProvider}" -o - - |
			plutil -insert 'Desktop.Content.Shuffle' -string '$null' -o - - |
			plutil -insert 'Desktop.LastSet' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Desktop.LastUse' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Idle' -dictionary -o - - |
			plutil -insert 'Idle.Content' -dictionary -o - - |
			plutil -insert 'Idle.Content.Choices' -array -o - - |
			plutil -insert 'Idle.Content.Choices' -dictionary -append -o - - |
			plutil -insert 'Idle.Content.Choices.0.Configuration' -data "${screenSaverBase64}" -o - - |
			plutil -insert 'Idle.Content.Choices.0.Files' -array -o - - |
			plutil -insert 'Idle.Content.Choices.0.Provider' -string 'com.apple.wallpaper.choice.screen-saver' -o - - |
			plutil -insert 'Idle.Content.Shuffle' -string '$null' -o - - |
			plutil -insert 'Idle.LastSet' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Idle.LastUse' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Type' -string 'individual' -o - -)"
	else
		# Index.plist contents.
		aerialDesktopAndScreenSaverSettingsPlist="$(plutil -create xml1 - |
			plutil -insert 'Desktop' -dictionary -o - - |
			plutil -insert 'Desktop.Content' -dictionary -o - - |
			plutil -insert 'Desktop.Content.Choices' -array -o - - |
			plutil -insert 'Desktop.Content.Choices' -dictionary -append -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Configuration' -data "${wallpaperBase64}" -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Files' -array -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Files' -dictionary -append -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Files.0.relative' -string "${wallpaperLocation}" -o - - |
			plutil -insert 'Desktop.Content.Choices.0.Provider' -string "${wallpaperProvider}" -o - - |
			plutil -insert 'Desktop.Content.Shuffle' -string '$null' -o - - |
			plutil -insert 'Desktop.LastSet' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Desktop.LastUse' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Idle' -dictionary -o - - |
			plutil -insert 'Idle.Content' -dictionary -o - - |
			plutil -insert 'Idle.Content.Choices' -array -o - - |
			plutil -insert 'Idle.Content.Choices' -dictionary -append -o - - |
			plutil -insert 'Idle.Content.Choices.0.Configuration' -data "${screenSaverBase64}" -o - - |
			plutil -insert 'Idle.Content.Choices.0.Files' -array -o - - |
			plutil -insert 'Idle.Content.Choices.0.Provider' -string 'com.apple.wallpaper.choice.screen-saver' -o - - |
			plutil -insert 'Idle.Content.Shuffle' -string '$null' -o - - |
			plutil -insert 'Idle.LastSet' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Idle.LastUse' -date "${currentRFC3339UTCDate}" -o - - |
			plutil -insert 'Type' -string 'individual' -o - -)"
	fi
	
	rm $loggedInUserHome/Library/Preferences/ByHost/com.apple.ScreenSaverPhotoChooser*.plist > /dev/null 2>&1
	rm $loggedInUserHome/Library/Preferences/ByHost/com.apple.ScreenSaver.iLifeSlideShows*.plist > /dev/null 2>&1

	su "$loggedInUser" -l -c "defaults write $PlistName SetCorpScreenSaver -bool Yes"
	su "$loggedInUser" -l -c "defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName '${ScreenSaveModuleName}' path '${PathToScreenSaver}' type 0"
    killall cfprefsd
	makeScreenSaverDirectory
}

function makeScreenSaverDirectory() {
	# Create the path to the screen saver/wallpaper Index.plist.
	echo "$(date) - Creating screen saver directory..."
	mkdir -p "${wallpaperStoreDirectory}"
	createIndexPlist
}

function createIndexPlist() {
	# Create the Index.plist
	echo "$(date) - Creating screen saver Index.plist..."
	plutil -create binary1 - |
		plutil -insert 'AllSpacesAndDisplays' -xml "${aerialDesktopAndScreenSaverSettingsPlist}" -o - - |
		plutil -insert 'Displays' -dictionary -o - - |
		plutil -insert 'Spaces' -dictionary -o - - |
		plutil -insert 'SystemDefault' -xml "${aerialDesktopAndScreenSaverSettingsPlist}" -o "${wallpaperStoreFullPath}" -
	killWallpaperAgent
}

function killWallpaperAgent() {
	# Kill the wallpaperAgent to refresh and apply the screen saver/wallpaper settings.
	echo "$(date) - Restarting wallpaper agent..."
	killall WallpaperAgent
	exitCode='0'
	finalize
}

function finalize() {
    echo ""
    if [[ "${exitCode}" == "0" ]]; then
        echo "$(date) - Mission accomplished!"
        exit 0
    else
        echo "$(date) - Abort mission..."
        exit 5
    fi    
}

#### MAIN ######

if [ "$4" = "" ]; then
    echo "Paramater 4 was empty"
    exit 1
fi

if [ "$5" = "" ]; then
    echo "Paramater 5 was empty"
    exit 2
fi

if [ "$6" = "" ]; then
    echo "Paramater 6 was empty"
    exit 3
fi


if [ "$7" = "" ]; then
    echo "Paramater 7 was empty"
    exit 4
fi


waitForLoggedInUser

if [ -e "$PathToScreenSaver" ]; then
	checkUserSettingsPlist
	getDefinedVariables
else
	echo "Cannot find $PathToScreenSaver"
	exit 0
fi
exit 0
