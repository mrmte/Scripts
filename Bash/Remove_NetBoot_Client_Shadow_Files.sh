#!/bin/bash

# To be used to remove netboot shadow files and restart the services

### ENVIRONMENT VARIABLES ###

files=$(ls /Library/NetBoot/NetBootClients0/* 2> /dev/null | wc -l)

### DO NOT MODIFY BELOW THIS LINE ###

if [ "$files" != "0" ]; then

echo "clearing NetBoot Clients folder"
rm -rf /Library/NetBoot/NetBootClients0/*
sudo serveradmin stop netiboot
sudo serveradmin start netboot

fi

exit 0
