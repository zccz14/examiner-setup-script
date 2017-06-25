#!/usr/bin/env bash

# client address
studentAddress=`echo $SSH_CLIENT | awk '{ print$1 }'`

if [[ -e ./log.${studentAddress} ]]; then
    echo student with id `cat ./log.${studentAddress}` has been registered on this machine
    exit 1
fi

read -p 'Student ID: ' studentID
read -p 'Password (hidden): ' -s regPassword
echo
read -p 'Password Confirmation(hidden): ' -s regConfirm
echo

echo "Your user name will be stu${studentID}"

echo "${studentID}" > ./log.${studentAddress}
echo "${studentID},`echo ${regPassword} | base64`,${studentAddress}" >> ./tester-info.csv
