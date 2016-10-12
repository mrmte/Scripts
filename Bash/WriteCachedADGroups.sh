#!/bin/bash
 
 
# This is to get the logged in used cached AD groups. This is using Apples' built in plugin
 
# The purpose of this is to read mobile cached account groups off network and report back to the JSS with an extension attribute
 
### ENVIRONMENT VARIABLES ###
 
# Get the currently logged in user information #
ConsoleUser=$(ls -l /dev/console | cut -d " " -f4)
 
query=$(dscl . read /Users/${ConsoleUser} OriginalAuthenticationAuthority | cut -d ';' -f 5)
 
# Domain
Domain=XXX
 
### DO NOT MODIFY BELOW THIS LINE ###
 
# check is a cached mobile account
if [[ $query = "$Domain" ]]; then
 
# Remove the previous file if it exists
if [ -f /Users/${ConsoleUser}/Library/ADgroups.txt ]; then
rm -rf /Users/${ConsoleUser}/Library/ADgroups.txt
fi
 
# get hex groups
dscl . read /Users/${ConsoleUser} cached_groups | sed '1d' >/tmp/hexgroups.txt
 
# Make the directory
if [ ! -d /tmp/staging ]; then
mkdir -p /tmp/staging
chflags hidden /tmp/staging
fi
 
# get up to 500 lines
for i in {1..500}; do
sed -n "${i}"p /tmp/hexgroups.txt | xxd -r -p >/tmp/staging/staginggroup$i.plist
done
 
# Remove the zero files
find /tmp/staging/ -size  0 -print0 |xargs -0 rm
 
 
FILES=/tmp/staging/*
for i in $FILES
do
defaults read $i dsAttrTypeStandard:RealName | tr -d '(,),"," "' | tail -n2 | head -n1 >>/Users/${ConsoleUser}/Library/ADgroups.txt
done
 
 
# Clean up
if [ -d  /tmp/staging ]; then
rm -rf /tmp/staging
fi
 
if [ -f /tmp/hexgroups.txt ]; then
rm -rf /tmp/hexgroups.txt
fi
 
fi
 
