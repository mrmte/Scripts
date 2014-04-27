#!/bin/bash

###################################################### INTRO #######################################################################################
#                                                                                                                                                  #
# In 10.8 onwards Expose doesn't exists anymore and Mission Control Exists instead                                                                 #
#   																		   
# This is to Make a symbolic link to link /Applications/Utilities/Expose to /Applications/Mission Control.                                         #
# 																	           
# This is so that some scripts will not fail when using the command /Applications/Utilities/Expose.app/Contents/MacOS/Expose 1 to show the Desktop #
#  																		   
####################################################################################################################################################

# Check to see if Expose exists!
if ls /Applications/Utilities/Expose.app/
then 

# Just echo to the console
echo "Already exists"
else

# Otherwise make the Symblic links
ln -sf /Applications/Mission\ Control.app/ /Applications/Utilities/Expose.app
ln -sf /Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control /Applications/Mission\ Control.app/Contents/MacOS/Expose
fi
exit 0
