#!/bin/bash

######## Environment Variables ##########


# Define a disabled printer
DisabledP=`lpstat -p | grep "disabled" | awk '{print $2}'`

####### Do Not Modify Below This Line ########

# Enable any disabled printers
cupsenable $DisabledP

exit 0
