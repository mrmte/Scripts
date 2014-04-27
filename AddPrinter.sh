#!/bin/bash

##############################################################################################################
#
# This is used to add a printer and make things easier using variables
#
# 1. Remove the printer if installed
#
# 2. Add the printer
#
# 3. Enabled any disabled printers
#
#############################################################################################################

########################################### ENVIRONMENT VARIABLES ###########################################

############ Server ############

# Server
Server=YOUR_SERVER

############ Printer Name ############

# Name
printer=YOUR_PRINTER_NAME

############ Printer Ports ############

# Port
port=lpd

############ Printer Location ############

# Printer Location
Location="YOUR LOCATION"

######### Printer Drivers ############

# Creative PPD
PPD=/Library/Printers/PPDs/Contents/Resources/en.lproj/YOUR_PPD

########### Printer Default Options #######

# Not shared
NShared="-o printer-is-shared=false"

################## Example of other Options that are possible depending on your PPD! ###################

# Doublesided Duplex or None
Duplex="-o Duplex=Duplex"

# Grayscale PrintAsGrayscale or PrintAsColor
Gray="-o XROutputColor=PrintAsGrayscale"

# Recyled Paper
Recycled="-o PaperType=RecycledPlain"

######## Status ##########

# Define a disabled printer
DisabledP=`lpstat -p | grep "disabled" | awk '{print $2}'`

######################################### DO NOT MODIFY BELOW THIS LINE ######################################

# Remove the printers
lpstat -p | awk '{print $2}' | grep "$Server-$printer" | while read printer
do
echo "Deleting Printer:" $printer
lpadmin -x $printer
done

#  Add Creative

if [ -f "$PPD" ]  ;then

/usr/sbin/lpadmin -p $Server-$printer -E -v $port://$Server/$printer -P "$PPD" -D "$Server-$printer" -L "$Location" $NShared

else echo "Driver Missing"

fi

# Clear all print queues 
cancel -a

# Enable any disabled printers
cupsenable $DisabledP

exit 0
