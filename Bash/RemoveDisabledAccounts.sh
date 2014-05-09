#!/bin/bash

###################################################################################################################################

#  PROBLEM
# 
#  If an account gets extended at the last minute in Active Directory, but the user has logged on to the machine previously then the 
#
#  database in the Assple OS (aka dscl) will not allow the user in because it gets marked by the dscl as "DisabledUser". 
#
#  We have to delete the account from dscl or enable it 
#
#
#  SOLUTION
#
#  To run this script to re-enable  disbaled accounts
#
#
##################################################################################################################################


# Check dscl to see if there are disabled accounts
for disableduser in `dscl . -list /Users AuthenticationAuthority | grep DisabledUser | awk '{print $1}' | tr '\n' ' '`; do

# Use pwpolicy to enable the disabled account
pwpolicy -a YOURADMIN -p YOURADMINPASSWORD -n /Local/Default -u $disableduser -enableuser

done

exit 0
