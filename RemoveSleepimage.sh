#!/bin/bash

# If the sleepimage file exists then remove it
if
ls /private/var/vm/sleepimage
then

# Set the power options to turn off the sleepimage
sudo pmset -a hibernatemode 0

# Pause 3 seconds
sleep 3

# Remove the Sleepimage file
rm -rf /private/var/vm/sleepimage

fi

