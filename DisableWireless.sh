#!/bin/bash


# This script checks to see if the machine is a MacBookPro. 			     
										     
# If it is not then the wireless services is disabled				     

# Get the wireless network service (wservice)
wservice=`/usr/sbin/networksetup -listallnetworkservices | grep -E '(Wi-Fi|AirPort)'`

# Get the wireless hardware port (whwport)
whwport=`networksetup -listallhardwareports | awk "/$wservice/,/Ethernet Address/" | awk 'NR==2' | cut -d " " -f 2`


# See if it is a Laptop
Laptop=`system_profiler SPHardwareDataType | grep -E "MacBookPro"`

if [ "$Laptop" ]; then
echo "Wireless Allowed"

# Disable the wirless interface if it exists

elif [ "$wservice" == "Wi-Fi" ]; then
/usr/sbin/networksetup -setnetworkserviceenabled $wservice off

elif [ "$wservice" == "AirPort" ]; then
/usr/sbin/networksetup -setnetworkserviceenabled $wservice off
fi


exit 0
