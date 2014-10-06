#!/bin/bash

/usr/bin/osascript <<END

try
        -- Kill spotflux
        do shell script "sh /Library/Management/Scripts/Quit_Spotflux.sh"
end try

try
        -- Kill Spotify
        do shell script "killall Spotify"

        -- Pause 5 seconds
        delay 5

        -- read the reference file
        set tunes to "spotify:user:kdog79:starred"


        -- Make sure shuffle & repeat is on
        tell application "Spotify"
                if shuffling is false then
                        set shuffling to true
                        if repeating is false then
                                set repeating to true
                        end if
                end if
        end tell

        delay 1


        tell application "Spotify"
                activate
                set sound volume to 0
                play track tunes
                next track
                tell application "Spotify" to pause
                delay 3
        end tell



        -- Bring Spotify to the front

        set appName to "spotify"
        set startIt to false
        tell application "System Events"
                if not (exists process appName) then
                        set startIt to true
                else if frontmost of process appName then
                        set visible of process appName to false
                else
                        set frontmost of process appName to true
                end if
        end tell
        if startIt then
                tell application appName to activate
        end if

        set radiourl to "http://somafm.com/popup/?groovesalad"

        -- Quit Safari web browser if it is running

        tell application "System Events"
                if (exists process "Safari") then
                        do shell script "killall Safari"
                end if
        end tell


        -- If Spotify is running the pause it and hide it

        tell application "System Events"
                if (exists process "Spotify") then
                        set visible of process "Spotify" to false
                        tell application "Spotify" to pause
                end if
        end tell

        -- If iTunes is running the pause it and hide it

        tell application "System Events"
                if (exists process "iTunes") then
                        set visible of process "iTunes" to false
                        tell application "iTunes" to pause
                end if
        end tell



        -- Open the required url

        do shell script "defaults write com.apple.Safari ApplePersistenceIgnoreState YES"

        tell application "Safari" to open location radiourl
        tell application "Safari"
                activate
        end tell

        delay 5


        -- Make Safari Full Screen
        tell application "Safari"

                activate
                tell application "System Events"
                        keystroke "f" using {control down, command down}
                end tell
        end tell

end try

END

exit 0
