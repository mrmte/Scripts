#!/bin/bash
: <<DOC

This is used to block connections to certain SSID's and to make sure when ethernet is plugged in Wi-Fi is turned off.

Note: this script is best to use with a launch dameon with a watch path to /Library/Preferences/SystemConfiguration/
example:

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.wifi.control.Launchd</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/sh</string>
		<string>/Library/Scripts/Wifi_Control.sh</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>WatchPaths</key>
	<array>
		<string>/Library/Preferences/SystemConfiguration/</string>
	</array>
</dict>
</plist>
DOC

# SSID's to block, if ALL are left empty below, nothing is blocked. You may just want to add one or two
Block1=""
Block2=""
Block3=""
Block4=""
Block5=""
Block6=""

##
# Define wireless interface "en" label.
wifiInterface=$(networksetup -listallhardwareports | grep 'Wi-Fi' -A1 | grep -o en.)
##
# Define wireless interface active status.
wifiStatus=$(ifconfig "${wifiInterface}" | grep 'status' | awk '{ print $2 }')
##
# Define wireless interface power status
wifiPower=$(networksetup -getairportpower "${wifiInterface}" | awk '{ print $4 }')
##
# Define non-wireless interface "en" labels.
ethernetInterface=$(networksetup -listallhardwareports | grep 'en' | grep -v "${wifiInterface}" | grep -o en.)
##
# Define non-wireless IP status.
ethernetIP=$(for i1 in ${ethernetInterface};do
  echo $(ifconfig "${i1}" | grep 'inet' | grep -v '127.0.|169.254.' | awk '{ print $2 }')
done)
##

function getSSID() {
ipconfig setverbose 1
CURRENT_SSID=$(ipconfig getsummary "${wifiInterface}" | awk -F ' SSID : ' '/ SSID : / {print $2}')
ipconfig setverbose 0
}

function stopAPIPA() {
        # Prevent 169 or 127 IP Address problem
                if ifconfig "${wifiInterface}" | grep '169.254.|127.0.' ;then

                # If APIPA turn wireless hardware port off
                /usr/sbin/networksetup -setairportpower "${wifiInterface}" off

                # turn wireless hardware port on
                /usr/sbin/networksetup -setairportpower "${wifiInterface}" on
                fi
return 0
}

# Disable active wireless interface if non-wireless interface connected.
if [[ "${ethernetIP}" && "${wifiStatus}" = "active" ]] || [[ "${ethernetIP}" && "${wifiPower}" = "On" ]]; then
  networksetup -setairportpower "${wifiInterface}" off
  touch /var/tmp/wifiDisabled; fi
##
# Enable inactive wireless interface if previously disabled by daemon.
if [[ "${ethernetIP}" = "" && "${wifiStatus}" = "inactive" ]] || [[ "${ethernetIP}" = "" && "${wifiPower}" = "Off" ]]; then
  if [[ -f "/var/tmp/wifiDisabled" ]]; then
    rm -f /var/tmp/wifiDisabled
    networksetup -setairportpower "${wifiInterface}" on; fi
    sleep 3    
    # stop 169 or 127 addresses
	stopAPIPA
	# Get the current SSID
    getSSID

	# If the connected SSID is in the block list turn wifi off and forget the blocked SSID and then turn Wi-Fi on again
    if [ -n "$Block1" ]||[ -n "$Block2" ]||[ -n "$Block3" ]||[ -n "$Block4" ]||[ -n "$Block5" ]||[ -n "$Block6" ]; then
      if [ "${CURRENT_SSID}" = "$Block1" ]||[ "${CURRENT_SSID}" = "$Block2" ]||[ "${CURRENT_SSID}" = "$Block3" ]||[ "${CURRENT_SSID}" = "$Block4" ]||[ "${CURRENT_SSID}" = "$Block5" ]||[ "${CURRENT_SSID}" = "$Block6" ]; then
 	/usr/sbin/networksetup -setairportpower "${wifiInterface}" off
	/usr/sbin/networksetup -removepreferredwirelessnetwork "${wifiInterface}" $Block1 >/dev/null 2>&1
	/usr/sbin/networksetup -removepreferredwirelessnetwork "${wifiInterface}" $Block2 >/dev/null 2>&1
	/usr/sbin/networksetup -removepreferredwirelessnetwork "${wifiInterface}" $Block3 >/dev/null 2>&1
	/usr/sbin/networksetup -removepreferredwirelessnetwork "${wifiInterface}" $Block4 >/dev/null 2>&1
	/usr/sbin/networksetup -removepreferredwirelessnetwork "${wifiInterface}" $Block5 >/dev/null 2>&1
	/usr/sbin/networksetup -removepreferredwirelessnetwork "${wifiInterface}" $Block6 >/dev/null 2>&1
	/usr/sbin/networksetup -setairportpower "${wifiInterface}" on
      fi
   fi
 fi
fi

# Sleep to prevent launchd interpreting as a crashed process.
sleep 10
exit 0
