#!/bin/bash

# Get the currently logged in user
user=`ls -l /dev/console | cut -d " " -f4`


# Check to see if the file exists
if [ ! -f /usr/local/bin/NCutil.py ]; then


# Download it
curl -L https://raw.githubusercontent.com/jacobsalmela/NCutil/master/NCutil.py -o /usr/local/bin/NCutil.py
sleep 5
chmod 775 /usr/local/bin/NCutil.py

fi

# Set Casper Management Notifications to Alerts
sudo su "${user}" -c '/usr/local/bin/NCutil.py -a alerts com.jamfsoftware.Management-Action'
