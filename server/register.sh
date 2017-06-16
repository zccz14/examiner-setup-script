#!/usr/bin/env bash

# client address
studentAddress=`echo $SSH_CLIENT | awk '{ print$1 }'`

read -p 'Student ID: ' studentID
read -p 'Password (hidden): ' -s regPassword
echo
read -p 'Password Confirmation(hidden): ' -s regConfirm
echo

echo "Your user name will be stu${studentID}"
echo "Your Password is ${regPassword} ${regConfirm}"