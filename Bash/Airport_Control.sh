#!/bin/bash
################################################################################################################################################
#
# HISTORY
#
# Version: 3.0
#
# - Created by Tim Kimpton on November 29th, 2012
# - Modified 2nd Feb 2019
# - Assisted by Jared Nichols and Mike from JAMFNATION to clean up and simplify the blocked ssid case statement and network interface variables
#
# Stops network bridging turning the relevant network interface off and on
#
################################################################################################################################################


THUNDERBOLT_ACTIVE_ETHERNET=""

USB_ACTIVE_ETHERNET=""

# SETTING THE ENVIRONMENT VARIABLES

ehwport1=$(networksetup -listallhardwareports | awk '/LAN/,/Ethernet Address/' | awk 'NR==2' | cut -d " " -f2)
  
ehwport2=$(networksetup -listallhardwareports | awk '/Thunderbolt/,/Ethernet Address/' | awk 'NR==2' | cut -d " " -f2)

ehwport3=$(ehwport=`networksetup -listallhardwareports | awk '/.Ethernet/,/Ethernet Address/' | awk 'NR==2' | cut -d " " -f 2`)

# Get the wireless network service (wservice)
wservice=$(/usr/sbin/networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|AirPort)')

# Get the wireless hardware port (whwport)
whwport=$(networksetup -listallhardwareports | awk "/$wservice/,/Ethernet Address/" | awk 'NR==2' | cut -d " " -f 2)

# Find the ALL network hardware ports (hwports)
hwports=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2)

# Get the wireless network (wirelessnw)
wirelessnw=$(networksetup -getairportnetwork $hwports | cut -d " " -f 4)

# Get the SSID
SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep ' SSID:' | cut -d ':' -f2 | tr -d ' ')

# Current Logged in User
consoleuser=$(ls -l /dev/console | cut -d " " -f4)

# Carry out an OS version check
OS=$(/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print substr($1,1,4)}')

# Work SSID
WorkSSID=YOUR_SSID

# Authentication to use
Auth=WPA2E

# Index for SSID
Index=0

# Department Allowed
Dept=YOURDEPARTMENTTOALLOW

# Change to YES if you set a proxy
Proxy="NO"

# SSIDs to Block

Block1=Lucky

Block2=YOURSSIDTOBLOCK

Block3=YOURSSIDTOBLOCK

Block4=YOURSSIDTOBLOCK

Block5=YOURSSIDTOBLOCK

Block6=YOURSSIDTOBLOCK

# Proxy value
autoProxyURL=""

# See if it is a Laptop
Laptop=$(system_profiler SPHardwareDataType | grep -E "MacBookPro")

# Check to see if the JSS is available and if yes, then submits the current IP
checkjss=$(/usr/local/bin/jamf checkJSSConnection -retry 0 | grep "The JSS is available")

function clearWifiDNS() {
/usr/sbin/networksetup -setdnsservers $wservice "empty"
return 0
}


function wifi_Check() {
if [[ "$THUNDERBOLT_ACTIVE_ETHERNET" != "YES" ]] && [[ "$USB_ACTIVE_ETHERNET" != "YES" ]] && [[ "$OTHER_ACTIVE_ETHERNET" != "YES" ]]; then
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs joinmode=automatic joinmodefallback=donothing
	/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $whwport $WorkSSID $Index $Auth  >/dev/null 2>&1
	/usr/sbin/networksetup -setairportpower $whwport on
fi
return 0
}

function Thunderbolt_Ethernet_Check() {
if ifconfig "${ehwport2}" | grep inet >/dev/null 2>&1; then
	echo "thunderbolt ethernet active"
	THUNDERBOLT_ACTIVE_ETHERNET="YES"
	/usr/sbin/networksetup -setairportpower $whwport off
	clearWifiDNS
	wifi_Check
fi
return 0
}

function USB_Ethernet_Check() {
/usr/sbin/networksetup -listallhardwareports | grep "Hardware Port: USB"
if [ "$?" = "0" ]; then
	if ifconfig "${ehwport1}" | grep inet >/dev/null 2>&1; then
	echo "usb ethernet active"
	USB_ACTIVE_ETHERNET="YES"
	/usr/sbin/networksetup -setairportpower $whwport off
	clearWifiDNS
	wifi_Check
	fi
fi
return 0
}

function Other_Ethernet_Check() {

/usr/sbin/networksetup -listallhardwareports | grep "Hardware Port: Ethernet"
if [ "$?" = "0" ]; then
	if ifconfig "${ehwport3}" | grep inet >/dev/null 2>&1; then
        echo "other ethernet active"
        OTHER_ACTIVE_ETHERNET="YES"
        /usr/sbin/networksetup -setairportpower $whwport off
        clearWifiDNS
        wifi_Check
	fi
fi
return 0
}


function stop_APIPA() {
        # Prevent 169 IP Address problem for  Work SSID
        if [[ "$SSID" == "$WorkSSID" ]]; then
                if ifconfig "${whwport}" | grep 169 ;then

                # If APIPA turn wireless hardware port off
                /usr/sbin/networksetup -setairportpower $whwport off

                # turn wireless hardware port on
                /usr/sbin/networksetup -setairportpower $whwport on
                fi
        fi
return 0
}

function block_SSIDs() {
# Get the wireless network (wirelessnw)
wirelessnw=$(networksetup -getairportnetwork $hwports | cut -d " " -f 4)

# Block  wireless networks
case $wirelessnw in
$Block1)
/usr/sbin/networksetup -setairportpower $whwport off
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block1
;;
esac

# CHECK IF ALLOWED
if dscl . -read /Users/"${consoleuser}" | grep "$Dept" ; then
   echo "$Dept Allowed!"
else

# Block the restricted wireless networks with a case statement below
   case $wirelessnw in
   $Block2|$Block3|$Block4|$Block5|$Block6)

# Turn off wifi
/usr/sbin/networksetup -setairportpower $whwport off
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block1 >/dev/null 2>&1
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block2 >/dev/null 2>&1
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block3 >/dev/null 2>&1
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block4 >/dev/null 2>&1
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block5 >/dev/null 2>&1
/usr/sbin/networksetup -removepreferredwirelessnetwork $whwport $Block6 >/dev/null 2>&1

# Set the preferred wireless network to WorkSSID
/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $whwport $WorkSSID $Index $AuthE >/dev/null 2>&1

;;
esac
fi

return 0
}


function proxy_check() {
if [[ "$Proxy" = "YES" ]]; then


# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$4" != "" ] && [ "$autoProxyURL" == "" ]; then
autoProxyURL=$4
fi

IFS=$'\n'

#Loops through the list of network services
for i in $(networksetup -listallnetworkservices | tail +2 );
do

# Get a list of all services beginning 'Ether' 'Air' or 'VPN' or 'Wi-Fi'
# If your service names are different to the below, you'll need to change the criteria
if [[ "$i" =~ 'Ether' ]] || [[ "$i" =~ 'Air' ]] || [[ "$i" =~ 'VPN' ]] || [[ "$i" =~ 'Wi-Fi' ]] ; then
        autoProxyURLLocal=$(/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-)

# Echo's the name of any matching services & the autoproxyURL's set
        echo "$i Proxy set to $autoProxyURLLocal"

# If the value returned of $autoProxyURLLocal does not match the value of $autoProxyURL for the interface $i, change it.
        if [[ $autoProxyURLLocal != $autoProxyURL ]] && [[ "$autoProxyURL" != "" ]]; then
                networksetup -setautoproxyurl $i $autoProxyURL
                echo "Set proxy for $i to $autoProxyURL"
        fi
fi

# Pause 3 seconds
sleep 3

done
fi
}

function send_jamf() {
if [ "$checkjss" == "The JSS is available." ]; then
        /usr/local/bin/jamf log
fi

}

##################### DO NOT MODIFY BELOW THIS LINE ####################################################

Thunderbolt_Ethernet_Check
USB_Ethernet_Check
Other_Ethernet_Check
wifi_Check
stop_APIPA
block_SSIDs
proxy_check
send_jamf

######################################################################

exit 0
