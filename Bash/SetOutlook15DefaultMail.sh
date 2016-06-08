#!/bin/bash

# Set Outlook as default email client
if [ -d /Applications/Microsoft\ Outlook.app ]; then

# Make the temporary directory
mkdir -p /tmp/duti > /dev/null 2>&1

# download the file source code
curl https://codeload.github.com/rtrouton/set_microsoft_outlook_as_default_application/zip/1.2 -o /tmp/duti/1.2.zip

# pause 15 seconds
sleep 15

# unzip the file
unzip /tmp/duti/1.2.zip -d /tmp/

# pause 15 seconds
sleep 15

# unzip the file
unzip /private/tmp/set_microsoft_outlook_as_default_application-1.2/application_source_components_and_graphics/pre-built_components/duti.zip -d /tmp/duti/

# pause 5 seconds
sleep 5

# move the file
mv /tmp/duti/duti /usr/local/bin/duti
chown root:admin /usr/local/bin/duti
chmod 755 /usr/local/bin/duti


# Set Microsoft Outlook as the default mail program

su $3 -c '/usr/local/bin/duti -s com.microsoft.outlook mailto'

# Set Microsoft Outlook as the default calendar program

su $3 -c '/usr/local/bin/duti -s com.microsoft.outlook ics all'

# Set Microsoft Outlook as the default contacts program

su $3 -c '/usr/local/bin/duti -s com.microsoft.outlook vcf all'

fi

exit 0
