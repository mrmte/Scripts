#!/bin/bash

###### ENVIRONMENT VARIABLES ######

# Check to see if spotlight is disabled on the partition
disabled1=`mdutil -i on / | grep "disabled" | awk '{print $4}'`

disabled2=`mdutil -s / | grep "disabled"`

###### DO NOT MODIFY BELOW THIS LINE ####

if [[ "$disabled1" == "disabled." ]]; then

# remove the offending file
rm /.metadata_never_index
fi

# make sure spotlight indexing is on
if [[ "$disabled2" == "Indexing disabled." ]]; then
mdutil -i on /
fi

exit 0
