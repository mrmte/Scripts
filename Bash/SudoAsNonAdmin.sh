#!/bin/bash

# Run this as root user
# This will allow a non admin to elevate as root eg sudo su
# If you have a touch ID mac this will offer touch id to authenticate
# The original /etc/pam.d/sudo is backed up with .bak_Y-m-d-H:M:S

# get the logged in user
USER=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

THEDATE=$(date "+%Y-%m-%d-%H:%M:%S")

# write the entry to the custom file
echo "$USER ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/sudoadmins

# correct permissions on the file
chown root:wheel /etc/sudoers.d/sudoadmins
chmod 755 /etc/sudoers.d/sudoadmins

# Take a back up of /etc/pam.d/sudo and then add entry to allow finder print athorisation
cp /etc/pam.d/sudo /etc/pam.d/sudo.bak_$THEDATE && echo "auth            sufficient      pam_tid.so\n$(cat /etc/pam.d/sudo)" >/etc/pam.d/sudo

exit 0
