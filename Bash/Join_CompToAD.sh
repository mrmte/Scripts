#!/bin/sh

############ ENVIROMENT VARIABLES ###############

# Computer hostname
HOSTNAME=`/bin/hostname | /usr/bin/cut -d "." -f 1`

# AD Account to use to join / remove from the domain
USER='ENTER YOUR VALUE'
PASS='ENTER YOUR VALUE'

# Specify the domain
DOMAIN='ENTER YOUR VALUE'

# Specify the OU
OU='ENTER YOUR VALUE'

########### DO NOT MODIFY BELOW THIS LINE ################

# Join the machine to AD
/usr/sbin/dsconfigad -f -a "$HOSTNAME" -u "$USER" -p "$PASS" -ou "$OU" -domain "$DOMAIN"

# Admin Settings 
/usr/sbin/dsconfigad -mobile enable
/usr/sbin/dsconfigad -mobileconfirm disable
/usr/sbin/dsconfigad -localhome enable
/usr/sbin/dsconfigad -useuncpath disable
/usr/sbin/dsconfigad -nopreferred
/usr/sbin/dsconfigad -groups "domain admins,enterprise admins"
/usr/sbin/dsconfigad -alldomains enable


# If the secure log exists then delete it!
if [ -f /var/log/secure.log ] ;then
/bin/rm /var/log/secure.log
fi
