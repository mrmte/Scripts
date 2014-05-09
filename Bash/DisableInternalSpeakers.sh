#!/bin/sh

# This is reliant on /bin/audiodevice

#http://forums.appleinsider.com/t/79221/how-to-disable-sound-output-through-internal-speakers

#http://whoshacks.blogspot.co.uk/2009/01/change-audio-devices-via-shell-script.html

#http://whosawhatsis.com/paraphernalia/audiodevice.zip

########################################

#infinite loop while system is on
# uncomment ## for loop NOT recommended
#turn off speakers if enabled


##while [ 1 ]
##do
OUTPUT=`audiodevice output`

if [ "$OUTPUT" = "Internal Speakers" ] ; then
osascript -e "set Volume 0"
fi
##done
