#!/bin/sh
####################################################################################################
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE
sgUsername=""
sgPassword=""
localAdmin=""
localPassword=""
driveToEncrypt="system"  # Choose one of these values: "uuid", "all", "index", "system"

####################################################################################################

# Create the SafeGuard User
echo "Creating SafeGuard user account with username: $sgUsername..."
/usr/bin/sgadmin --add-user --type admin --user "$sgUsername" --password "$sgPassword" --confirm-password "$sgPassword" --authenticate-user "$localAdmin" --authenticate-password "$localPassword"

# Pause 5 seconds
sleep 5

# Encrypt the drive
echo "Initiating encryption process on disk: $driveToEncrypt..."
/usr/bin/sgadmin --encrypt "$driveToEncrypt" --authenticate-user "$sgUsername" --authenticate-password "$sgPassword"
/usr/bin/sgadmin --enable-fast

# Enable Firmware Updates
/usr/bin/sgadmin --enable-firmware-update --authenticate-user "$sgUsername" --authenticate-password "$sgPassword"

exit 0 
