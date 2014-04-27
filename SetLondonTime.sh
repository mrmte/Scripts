#!/bin/bash

# Check to see if the ntpd is set correctly
if
/usr/sbin/systemsetup -getnetworktimeserver | grep "YOURNTPSERVERIP"
then echo "Machine has the correct ntpd of YOURNTPSERVERIP"

# If it isn't set correctly the we need to change it!
else

# Remove old symbolic link
rm -rf /etc/localtime

# Set London Time Time Zone
/usr/sbin/systemsetup -settimezone Europe/London

# Set London Time Server
/usr/sbin/systemsetup -setnetworktimeserver YOURNTPSERVERIP

# Set Using Network Time Server On
/usr/sbin/systemsetup -setusingnetworktime on

# Set timezone by creating a symbolic link
ln -sf "/usr/share/zoneinfo/Europe/London" "/etc/localtime"

# Create a symbolic link for DNS
ln -sf "/private/var/run/resolv.conf" "/etc/resolv.conf"

fi
