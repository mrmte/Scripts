#!/bin/bash

##############################
# This script is to stop annoying "boink audio systems sounds in the open plan office!			
#														     
# This is to be used either with a policy or launch daemon to run at login					      
# 														      
# This is to 													      
#														      
# 1.disable user interface sound effects									      
#														      
# 2.disable feedback when volume is changed 									      
#														      
# 3.turn down the Alert volume.											      
#														      
# 4. mute the system volume											      
#														      
#######################################################################################################################

################################################# ENVIRONMENT VARIABLES ############################################### 

user=`ls -l /dev/console | cut -d " " -f4`

################################################ DO NOT MODIFY BELOW THIS LINE ########################################

# Turn off "Play feedback when volume is changed
su "${user}" -c 'defaults write -g com.apple.sound.beep.feedback -integer 0'

# Turn off "Play user interface sound effects
su "${user}" -c 'defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0'

# Turn the volume down the alert volume
su "${user}" -c 'defaults write com.apple.systemsound com.apple.sound.beep.volume -float 0'

exit 0
