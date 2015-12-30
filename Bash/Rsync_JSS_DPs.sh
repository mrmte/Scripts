#!/usr/bin/expect -f

# This expect script can be used if rsa ssh keygen is not working with public and private keys

# idea from here http://www.scriptscoop.net/t/969088e3590f/android-im-having-problems-executing-the-expect-command-in-bash-on-osx.html

# This is reliant on a password file

# customise the variables for your environment

### ENVIRONMENT VARIABLES ###

# User to connect with
USER='XXX'

# Password file to read from
PASSWORD=$(cat XXX)

# The source server
SERVER_SOURCE='XXX'

# The location on the SERVER_SOURCE of the data to replicate
PATH_SOURCE='XXX'

# The location on the local machine destination
DESTINATION_PATH='XXX'

### DO NOT MODIFY BELOW THIS LINE ###

expect <<END

spawn rsync -avrpogz --delete --exclude=.Trashes/ --exclude=.Spotlight-v100/ -e ssh $USER@$SERVER_SOURCE:$PATH_SOURCE $DESTINATION_PATH

expect "Password:"
send "$PASSWORD\r"
expect eof
END
