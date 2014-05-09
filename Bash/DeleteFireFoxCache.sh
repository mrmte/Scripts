#!/bin/bash

### History ###

# To combat AV alerts from firefox browser caches

############## ENVIRONMENT VARIABLES ####################

Path=/Users/*/Library/Caches/Firefox/Profiles/*.default/Cache/*

App=firefox

###################### DO NOT MODIFY BELOW THIS LINE ####################

# Force quit the app
killall -9 $App

# Deleting all the users Firefox caches for security purposes
rm -rf $Path
