#!/bin/bash

############# ENVIRONMENT VARIABLES #############

App1=Microsoft

App2=Reminders


############# DO NOT MODIFY BELOW THIS LINE ##############

# Killall the required app

kill `ps auxww | grep $App1 | awk '{print$2}'`

kill `ps auxww | grep $App2 | awk '{print$2}'`
