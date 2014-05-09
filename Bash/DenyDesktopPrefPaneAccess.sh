#!/bin/bash

################### VARIABLES #############################################

# Carry out an OS version check
OS=`/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print substr($1,1,4)}'`

#################### DO NOT MODIFY BELOW THIS LINE #########################
if [[ "$OS" == "10.8" ]]; then
# Prevent Access to the prefpane
chmod -R 750 /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/DesktopPictures.prefPane/Contents/Resources/English.lproj/DSKDesktopWindow.nib
chmod -R 750 /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/ScreenEffects.prefPane/Contents/Resources/English.lproj/ScreenSaverPref.nib

elif [[ "$OS" == "10.6" ]]; then
chmod -R 750 /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/English.lproj/DesktopScreenEffectsPref.nib
chmod -R 750 /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/ScreenEffects.prefPane/Contents/Resources/English.lproj/ScreenSaverPref.nib
fi
