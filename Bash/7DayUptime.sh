#!/bin/bash

# Specify to run it as an OS applesctipt specifying it ends at EOT
/usr/bin/osascript <<EOT

set uptimeResult to do shell script "uptime"
set {TID, text item delimiters} to {text item delimiters, "up  "}
set uptimeResult to text item 1 of uptimeResult
set text item delimiters to ","
set uptimeResult to text item 1 of uptimeResult
set text item delimiters to TID

try

if uptimeResult contains "days" then
set numberOfDays to word 1 of uptimeResult as integer
if numberOfDays > 7 then
tell application "Finder"
activate
display dialog "Your computer has not been restarted for over a week. Please reboot as soon as possible to ensure that all security patches deployed to the machine are applied. This also helps the machine run at optimum performance. " with title "RL Uptime Warning"
end tell
end if
end if
	
end try

EOT
exit 0
