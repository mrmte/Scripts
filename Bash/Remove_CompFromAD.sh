#!/bin/bash

############ ENVIROMENT VARIABLES ###############

# Computer hostname
HOSTNAME=`/bin/hostname | /usr/bin/cut -d "." -f 1`

# AD Account to use to join / remove from the domain
USER='ENTER YOUR VALUE'
PASS='ENTER YOUR VALUE'

# Specify the domain
DOMAIN='ENTER YOUR VALUE'

########### DO NOT MODIFY BELOW THIS LINE ################

# Remove the machine to AD
/usr/sbin/dsconfigad -f -remove "$HOSTNAME" -u "$USER" -p "$PASS"
