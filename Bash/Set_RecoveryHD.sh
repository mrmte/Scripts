!/bin/sh

InstaDMGRecovery="Macintosh HD"
RecoveryHDID=`/usr/sbin/diskutil list | grep "$InstaDMGRecovery" | awk 'END { print $NF }'`
AppleRecovery="Recovery HD"
UnMount=`/usr/sbin/diskutil list | grep "$AppleRecovery" | awk 'END { print $NF }'`

# Mount the volume
/usr/sbin/diskutil mount /dev/"$RecoveryHDID"

# Rename the volume
diskutil rename /Volumes/"$InstaDMGRecovery" "$AppleRecovery"

# Pause 5 Seconds
sleep 5

# Unmount the volume
/usr/sbin/diskutil unmount /dev/"$UnMount"

# Delete the LaunchDaemon so that it will not run again!
rm -rf /Library/LaunchDaemons/com.recovery.hd.Launchd.plist
