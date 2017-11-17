#!/bin/bash

# turn off case sensitive
shopt -s nocasematch

# This is designed to relaunch Global Protect upon wake using sleepwatcher


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
if [ ! -f /etc/rc.wake ]; then


cat << EOF | base64 -D > /etc/rc.wake
IyEvYmluL2Jhc2gKCmxvZ2dlZEluVXNlcj1gcHl0aG9uIC1jICdmcm9tIFN5c3Rlb
UNvbmZpZ3VyYXRpb24gaW1wb3J0IFNDRHluYW1pY1N0b3JlQ29weUNvbnNvbGVVc2VyOyBp
bXBvcnQgc3lzOyB1c2VybmFtZSA9IChTQ0R5bmFtaWNTdG9yZUNvcHlDb25zb2xlVXNlcih
Ob25lLCBOb25lLCBOb25lKSBvciBbTm9uZV0pWzBdOyB1c2VybmFtZSA9IFt1c2VybmFtZS
wiIl1bdXNlcm5hbWUgaW4gW3UibG9naW53aW5kb3ciLCBOb25lLCB1IiJdXTsgc3lzLnN0Z
G91dC53cml0ZSh1c2VybmFtZSArICJcbiIpOydgCgoKaWYgcHMgYXV4IHwgZ3JlcCAtaSAi
W0ddbG9iYWxQcm90ZWN0IjsgdGhlbgpraWxsYWxsIEdsb2JhbFByb3RlY3QKc3UgJGxvZ2d
lZEluVXNlciAtYyAnb3BlbiAvQXBwbGljYXRpb25zL0dsb2JhbFByb3RlY3QuYXBwJwpmaQ
oKZXhpdCAwCg==
EOF
fi

# CREATE THE LAUNCH DAEMON IF IT DOESNT EXIST
if [ ! -f /Library/LaunchDaemons/com.servicenow.sleepwatcher.Launchd.plist ]; then
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
</plist>" >/Library/LaunchDaemons/com.servicenow.sleepwatcher.Launchd.plist

# CORRECT PERMISSIONS ON THE LAUNCH DAEMON
chown root:wheel /Library/LaunchDaemons/com.servicenow.sleepwatcher.Launchd.plist
chmod 600 /Library/LaunchDaemons/com.servicenow.sleepwatcher.Launchd.plist

# LOAD THE LAUNCH DAEMON
launchctl load -w /Library/LaunchDaemons/com.servicenow.sleepwatcher.Launchd.plist
fi

exit 0
# Unset no case match
shopt -u nocasematch
