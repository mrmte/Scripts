#!/bin/bash

############## SETUP SLEEPWATCHER ############### 

# IF IT DOESNT EXIST DOWNLOAD TO /tmp
if [ ! -f /usr/local/bin/sleepwatcher ]; then
curl -L http://www.bernhard-baehr.de/sleepwatcher_2.2.tgz -o /tmp/sleepwatcher.tgz
cd /tmp

# EXTRACT THE FILE
tar -xf /tmp/sleepwatcher.tgz

# MOVE THE FILES
mv /tmp/sleepwatcher*/sleepwatcher /usr/local/bin/
mv /tmp/sleepwatcher*/sleepwatcher.8 /usr/local/share/man/man1/sleepwatcher.1
fi

# IF IT /etc/rc/sleep DOESNT EXIST CREATE IT & POPULATE THE CONTENTS
if [ ! -f /etc/rc.sleep ]; then
# Echo the contents to /etc/rc.sleep
echo "#!/bin/bash

defaults write $USER/Library/Preferences/com.apple.screensaver.plist askForPassword -int 1
defaults write $USER/Library/Preferences/com.apple.screensaver.plist askForPasswordDelay -float 0.0
chmod 777 $USER/Library/Preferences/com.apple.screensaver.plist

osascript -e 'tell application System Events to set require password to wake of security preferences to true'" >/etc/rc.sleep

# EVERYONE FULL PERMISSIONS
chmod 777 /etc/rc.sleep

# CORRECT THE FILE /etc/rc.sleep
sed -i bak -e 's/System Events/"System Events"/g' /etc/rc.sleep
fi

# CREATE THE LAUNCH DAEMON IF IT DOESNT EXIST
if [ ! -f /Library/LaunchDaemons/com.sn.sleepwatcher.Launchd.plist ]; then
# Create the launch daemon
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>de.bernhard-baehr.sleepwatcher</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/bin/sleepwatcher</string>
		<string>-V</string>
		<string>-s /etc/rc.sleep</string>
		<string>-w /etc/rc.wakeup</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
</dict>
</plist>" >/Library/LaunchDaemons/com.sn.sleepwatcher.Launchd.plist

# CORRECT PERMISSIONS ON THE LAUNCH DAEMON
chown root:wheel /Library/LaunchDaemons/com.sn.sleepwatcher.Launchd.plist
chmod 600 /Library/LaunchDaemons/com.sn.sleepwatcher.Launchd.plist

# LOAD THE LAUNCH DAEMON
launchctl load -w /Library/LaunchDaemons/com.sn.sleepwatcher.Launchd.plist
fi

############ ADD KEYCHAIN LOCK TO ALL USERS MENU BAR #############

# https://groups.google.com/forum/#!msg/macenterprise/Zm_sZhjnTzU/3rwdIJJzazYJ

############ ENVIRONMENT VARIABLES ############

#PROVIDE THE PATH
newMenuExtra="/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu"

########## DO NOT MODIFY BELOW THIS LINE ##########

# ALL USERS IN /USERS/
for userAccount in /Users/*
do

# SEARCH FOR IT 
menuExtraExists=`/usr/bin/defaults read $userAccount/Library/Preferences/com.apple.systemuiserver menuExtras | /usr/bin/grep -e "Keychain.menu"`

# IF IT DOESNT EXIST ADD IT
if [ -z "$menuExtraExists" ]
  then
    /usr/bin/defaults write $userAccount/Library/Preferences/com.apple.systemuiserver menuExtras -array-add "$newMenuExtra"
# correct permissions on the file
chmod 777 $userAccount/Library/Preferences/com.apple.systemuiserver.plist

# KILL PREFERENCE CACHING DAEMON
killall cfprefsd

# KILL SYSTEMUISERVER
/usr/bin/killall SystemUIServer
###
fi
done

# USER TEMPLATE FOLDER

# SEARCH FOR IT
touch /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.systemuiserver.plist
menuExtraExists=`/usr/bin/defaults read /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.systemuiserver menuExtras | /usr/bin/grep -e "Keychain.menu"`

# IF IT DOESNT EXIST ADD IT
if [ -z "$menuExtraExists" ]
  then
    /usr/bin/defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.systemuiserver menuExtras -array-add "$newMenuExtra"
# correct permissions on the file
chmod 777 /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.systemuiserver.plist
fi

####### SCREEN LOCK ALL USER ACCOUNTS ##########

for userAccount in /Users/*
do
defaults write $userAccount/Library/Preferences/com.apple.screensaver.plist askForPassword -int 1
defaults write $userAccount/Library/Preferences/com.apple.screensaver.plist askForPasswordDelay -float 0.0
chmod 777 $userAccount/Library/Preferences/com.apple.screensaver.plist
done

##### SCREEN LOCK FOR USER TEMPLATE #####

defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.screensaver.plist askForPassword -int 1
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.screensaver.plist askForPasswordDelay -float 0.0
chmod 777 /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.screensaver.plist

exit 0

