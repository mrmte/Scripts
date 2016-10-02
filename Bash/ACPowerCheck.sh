#!/bin/bash

# check if machine is running on power

# If machine is a Laptop and is running on Battery, go through and loop the message before continuing
while [[ $(pmset -g ps | head -1 | cut -d "'" -f 2)  != "AC Power" ]]; do

# Display the message
osascript -e 'tell app "System Events" to display dialog "You need to connect the machine to AC Power to continue" buttons {"OK"} default button 1'
done
