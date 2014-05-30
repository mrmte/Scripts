#!/bin/bash

# This script is used to make sure the users data is set to a separate HDD on a partition called USERDATA for Mac Pro machines ONLY.

# This is to make things easier for machine rebuilds and disaster recovery. The user will not need to back up their data prior to a machine rebuild if this is in place.

# This works only with an existing fstab in the imaging process

############ Hardcoded variables are set here ##################

file=`ls /etc/fstab`
model=`system_profiler | egrep Model\ Identifier | grep MacPro`
hdd=`system_profiler SPSerialATADataType | grep USERDATA | cut -d: -f1`

if 
ls /Volumes/USERDATA ; then
# Get the UUID of the Volume USERDATA
usersUUID=`diskutil info /Volumes/RLUSERS | grep Volume\ UUID: | awk '{print $3}'`
else
# Get the UUID of /Users
usersUUID=`diskutil info /Users | grep Volume\ UUID: | awk '{print $3}'`
fi

############ Do Not Modify Below This Line #####################


# Check to see if its a MacPro and fstab exists
if  [ "${file}" ] && [ "${model}" ] && [ "${hdd}" ] ; then

# Move the Shared folder to USERDATA
mv /Users/Shared/ /Volumes/"${hdd}"/Shared/

# Pause 10 seconds
sleep 10

# Make sure the volume USERDATA is hidden
/usr/bin/SetFile -a V /Volumes/"${hdd}"
/usr/bin/SetFile -a V /Users


# Output the UUID to the fstab file
echo >> $1/private/etc/fstab "UUID=$usersUUID\t/Users\thfs\trw"

# Change the ownership of the file
chown root:wheel $1/private/etc/fstab
chmod 755 $1/private/etc/fstab

# Otherwise don't do anything
else
echo "Don't do anything conditions not met!"


# Remove the launch daemon
rm -rf /Library/LaunchDaemons/com.userdata.fstab.Launchd.plist

fi

# Remove the script
rm -rf /Library/Management/Scripts/fstab_USERDATA.sh
exit 0
