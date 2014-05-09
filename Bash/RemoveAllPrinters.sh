#!/bin/bash

#################### HISTROY ############################
#                                                       #
# Created By Tim Kimpton                                #
#                                                       #
# 6/3/2013                                              #
#                                                       #
# This is Used to remove all the printers off a machine.#
#                                                       #
#                                                       #
#########################################################

# Removing all printer
lpstat -p | awk '{print $2}' | while read printer
do
echo "Deleting Printer:" $printer
lpadmin -x $printer
done


