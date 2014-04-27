#!/bin/bash

# This is used to tell the OS to get another IP Address from the DHCP server

# For the 3 different possible interfaces scutil to refresh the network configuration

# For further information see 

# http://apple.stackexchange.com/questions/17401/how-can-i-release-and-renew-my-dhcp-lease-from-terminal 

echo "add State:/Network/Interface/en0/RefreshConfiguration temporary" | sudo scutil
echo "add State:/Network/Interface/en1/RefreshConfiguration temporary" | sudo scutil
echo "add State:/Network/Interface/en2/RefreshConfiguration temporary" | sudo scutil

exit 0
