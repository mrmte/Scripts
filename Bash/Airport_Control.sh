#!/bin/bash
################################################################################################################################################
#
# HISTORY
#
# Version: 2.9
#
# - Created by Tim Kimpton on November 29th, 2012
# - Assisted by Jared Nichols and Mike from JAMFNATION to clean up and simplify the blocked ssid case statement and network interface variables
#
# Stops network bridging turning the relevant network interface off and on
#
################################################################################################################################################


# SETTING THE ENVIRONMENT VARIABLES

# Get the ethernet hardware port (ehwport)
ehwport=`networksetup -listallhardwareports | awk '/.Ethernet/,/Ethernet Address/' | awk 'NR==2' | cut -d " " -f 2`

# Get the wireless network service (wservice)
wservice=`/usr/sbin/networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|AirPort)'`

# Get the wireless hardware port (whwport)
whwport=`networksetup -listallhardwareports | awk "/$wservice/,/Ethernet Address/" | awk 'NR==2' | cut -d " " -f 2`

# Find the ALL network hardware ports (hwports)
hwports=`networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`

# Get the wireless network (wirelessnw)
wirelessnw=`networksetup -getairportnetwork $hwports | cut -d " " -f 4`

# Get the SSID
SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I\
| grep ' SSID:' | cut -d ':' -f 2 | tr -d ' '`

# Current Logged in User
consoleuser=`ls -l /dev/console | cut -d " " -f4`

# Carry out an OS version check
OS=`/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print substr($1,1,4)}'`

# Work SSID
WorkSSID=RLCORP001

# Authentication to use
Auth=WPA2E

# Index for SSID
Index=0

# Department Allowed
Dept=YOURDEPARTMENTTOALLOW

# SSIDs to Block

Block1=YOURSSIDTOBLOCK

Block2=YOURSSIDTOBLOCK

Block3=YOURSSIDTOBLOCK

Block4=YOURSSIDTOBLOCK

Block5=YOURSSIDTOBLOCK

Block6=YOURSSIDTOBLOCK

# Proxy value
autoProxyURL="YOURAUTOPACFILE IF REQUIRED"

# See if it is a Laptop
Laptop=`system_profiler SPHardwareDataType | grep -E "MacBookPro"`

# Check to see if the JSS is available and if yes, then submits the current IP
checkjss=`/usr/sbin/jamf checkJSSConnection -retry 0 | grep "The JSS is available"`

##################### DO NOT MODIFY BELOW THIS LINE ####################################################

# See if ethernet if active and if it is then we need to turn OFF the wirelesss interface!
if ifconfig "${ehwport}" | grep inet; then
/usr/sbin/networksetup -setairportpower $whwport off

# There is also a bug where wireless network interfaces are caching DNS and causes problems when switching networks, so we need to clear them!
/usr/sbin/networksetup -setdnsservers $wservice "empty"

# if Ethernet is not active then...
elif ifconfig "${ehwport}" | grep inactive; then

# Clear the DNS cache for the wireless network service
/usr/sbin/networksetup -setdnsservers $wservice "empty"

# Do not ask to join new networks
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport prefs joinmode=automatic joinmodefallback=donothing

# Set the preferred wireless network to WorkSSID
/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $whwport $WorkSSID $Index $Auth

# Turn the wirless hardware port on
/usr/sbin/networksetup -setairportpower $whwport on
fi

# Prevent 169 IP Address problem for  Work SSID
if [ $SSID = $WorkSSID ]; then
if ifconfig "${whwport}" | grep 169;
then

# If APIPA turn wireless hardware port off
/usr/sbin/networksetup -setairportpower $whwport off

# turn wireless hardware port on
/usr/sbin/networksetup -setairportpower $whwport on
fi
fi

# Get the wireless network (wirelessnw)
wirelessnw=`networksetup -getairportnetwork $hwports | cut -d " " -f 4`

# Block  wireless networks
case $wirelessnw in
$Block1)
networksetup -setairportpower $whwport off
;;
esac

# CHECK IF ALLOWED
if
dscl . -read /Users/"${consoleuser}" | grep "$Dept"
then echo "$Dept Allowed!"
else

# Block the restricted wireless networks with a case statement below
case $wirelessnw in
$Block2|$Block3|$Block4|$Block5|$Block6)

# Turn off wifi
networksetup -setairportpower $whwport off

# Set the preferred wireless network to WorkSSID
/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $whwport $WorkSSID $Index $AuthE

# Remove Wireless networks
/usr/sbin/networksetup -removeallpreferredwirelessnetworks $whwport

;;
esac
fi


######################################################################

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
autoProxyURLLocal=`/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-`

# Echo's the name of any matching services & the autoproxyURL's set
echo "$i Proxy set to $autoProxyURLLocal"

# If the value returned of $autoProxyURLLocal does not match the value of $autoProxyURL for the interface $i, change it.
if [[ $autoProxyURLLocal != $autoProxyURL ]]; then
networksetup -setautoproxyurl $i $autoProxyURL
echo "Set proxy for $i to $autoProxyURL"
fi
fi

# Pause 3 seconds
sleep 3

# Submit info to JSS if available
if [ "$checkjss" == "The JSS is available." ]; then
/usr/sbin/jamf log
fi
done

exit 0
