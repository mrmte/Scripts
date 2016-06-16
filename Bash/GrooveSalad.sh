#!/bin/bash

/usr/bin/osascript <<END

#!/bin/bash



try
	-- Kill Spotify
	do shell script "killall Spotify"
end try
-- Pause 5 seconds
delay 5

try
	set radiourl to "http://somafm.com/player/#/now-playing/groovesalad"
	
	-- Quit Safari web browser if it is running
	
	tell application "System Events"
		if (exists process "Safari") then
			do shell script "killall Safari"
		end if
	end tell
	
	-- Quit iTunes if ru nning
	
	tell application "System Events"
		if (exists process "iTunes") then
			set visible of process "iTunes" to false
			tell application "iTunes" to pause
		end if
	end tell
	
	
	
	-- Open the required url
	
	do shell script "defaults write com.apple.Safari ApplePersistenceIgnoreState YES"
	
	set volume output volume 50
	
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
