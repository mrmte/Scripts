#!/bin/bash

# Removing Apps Store
rm -rf /Library/Preferences/com.apple.dockfixup.plist

# Removing Previous logs
rm -rf /private/var/unauthorized_application

# Make sure PATH has a safe value, so we don't have to
# spell out command names in full
PATH=/bin:/usr/bin

# We're going to maintain several files, so group them all together
logdir=/private/var/unauthorized_application

# Make the log directory
mkdir -p "$logdir"

# Generate a list of application names, separated by \0 characters
# Use -iname rather than -name, so they can't hide an app as .APP
# 404504568 is domain user in this example
find -x / -iname '*.app' -group 404504568 -print0 > "$logdir"/new

# If desired, append the list of names to a cumulative logfile, one per line
tr "\0" "\n" < "$logdir"/new >> "$logdir"/names.log

# If desired, append ls -l output to a different logfile
cat "$logdir"/new | xargs -0 ls -l >> "$logdir"/ls.log

# If desired, delete the applications (which are probably bundles)
cat "$logdir"/new | xargs -0 rm -rf

# If desired, clean up
rm "$logdir"/new

# Pausing 10 minutes to prevent multiple find commands causing kernel panics
sleep 600

# Delete those dmg files users are downloading
find -x / -iname '*.dmg' -group 404504568 -print0 | xargs -0 rm -rf



