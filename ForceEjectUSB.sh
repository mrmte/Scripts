#!/bin/sh

# Get the disk name
for disk in $(diskutil list | awk '/disk[1-9]s/{ print $NF }' | grep -v /dev); do
if [[ $(diskutil info $disk | awk '/Protocol/{ print $2 }') == "USB" ]]; then
echo "Device $disk is a USB removable disk"
diskName=$(diskutil info $disk | awk -F"/" '/Mount Point/{ print $NF }')

# Eject the disk
diskutil unmountDisk $diskName

fi
done
