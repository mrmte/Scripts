#!/bin/sh

# comment in for debug output
# set -x

# configuration
NUM_RECOVERY_USERS=5
DATE=`date "+%d-%m-%y_%H.%M"`
DUMP_FILE="/var/tmp/recovery_users"
DUMP_FOLDER="/var/tmp/Sophos_SafeGuard"
# setup absolute paths to all binaries we use
SGADMIN="/usr/bin/sgadmin"
WC="/usr/bin/wc"
GREP="/usr/bin/grep"
ECHO="/bin/echo"
USER="$1"
# TODO: get admin credentials, e.g. from file, or stdin ...
ADMIN="YOURSGNADMINACCOUNT"
PWDADMIN="YOURSGNADMINPASSWORD"



# creating the user account if it doesn't exits on the machine with a default password.
"${SGADMIN}" --add-user --type user --user "${USER}" --password 3TUBbEny --confirm-password 3TUBbEny --authenticate-user "${ADMIN}" --authenticate-password "${PWDADMIN}"

# check input
if [ -z "$1" ]; then
        ${ECHO} "Error, no username given. Usage: '`basename $0` username'"
        exit 1
fi

# setup regex for finding user
REGEX_USER="^\| user: ${USER}.*\| type: .* \| created: .* \| modified: .* \|$"

# setup regex for finding recovery users
REGEX_RECOVERY_USER="^\| user: .* \| type: recovery \| created: .* \| modified: .* \| recovers: ${USER}.*\|$"

# check if user ${USER} exists
${SGADMIN} --list-users --authenticate-user "${ADMIN}" --authenticate-password "${PWDADMIN}" \
	| ${GREP} -E "${REGEX_USER}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	${ECHO} "Error, user '${USER}' does not exist."
	exit 1
fi

# count recovery users for user ${USER}
ACTUAL_RECOVERY_USERS=`${SGADMIN} --list-users --authenticate-user "${ADMIN}" --authenticate-password "${PWDADMIN}" \
	| ${GREP} -E "${REGEX_RECOVERY_USER}" | ${WC} -l`

# how many additional recovery users do we need?
declare -i DIFF="${NUM_RECOVERY_USERS} - ${ACTUAL_RECOVERY_USERS}"

if [ ${DIFF} -gt 0 ]; then

hostname>"${DUMP_FILE}"
${ECHO} "Creating recovery users for user '${USER}':" >> "${DUMP_FILE}" 2>&1
	${SGADMIN} --add-recovery-users --authenticate-user "${ADMIN}" --authenticate-password "${PWDADMIN}" \
		--user-to-recover "${USER}" --count "${DIFF}" >> "${DUMP_FILE}" 2>&1 

# make the Sophos_SafeGuard folder
mkdir "${DUMP_FOLDER}"

# Pausing 5 seconds
sleep 5

# changing ownership, read, write and execute permissions of the Sophos_SafeGuard folder so that new txt files can be written to it
chmod -R 777 "${DUMP_FOLDER}"

# moving the recovery users file to the Sophos_SafeGuard folder
mv "${DUMP_FILE}" /"${DUMP_FOLDER}"/recovery_users_"${DATE}".txt	

# for security changing ownership, read, write and execute permissions of the Sophos_SafeGuard folder and all files within it so that only root and group admin have access 
chown -R root:admin "${DUMP_FOLDER}"
chmod -R 770 "${DUMP_FOLDER}"

# pausing 5 seconds
sleep 5

if [ $? -ne 0 ]; then
		${ECHO} "Error, '${SGADMIN}' exited with error code '$?'."
		exit 1
	fi
	${ECHO} "Successfully created ${DIFF} recovery users for user '${USER}'. Additional information can be found in '${DUMP_FOLDER}'"
fi


exit 0

