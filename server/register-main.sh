#!/usr/bin/env bash

# client address
studentAddress=`echo $SSH_CLIENT | awk '{ print$1 }'`

if [[ -e ./log.${studentAddress} ]]; then
    echo student with id `cat ./log.${studentAddress}` has been registered on this machine
    exit 1
fi

studentID=""
regPassword=""
regConfirm=""

function validateStudentID() {
    if ! [[ "$studentID" =~ ^[0-9]{10}$ ]]; then
        echo 'StudentID should contains 10 digits (0~9) only'
        return 1
    fi
    return 0
}

# Validate the format of password
# the rules here constraints the password consisted of only digits and letters 
# (considering the bash environment may expose characters to other interpretation)
function validatePassword() {
    if ! [[ $regPassword =~ ^[0-9A-Za-z]{6,20}$ ]]; then 
        echo 'Password should contains at least 6 characters but no more than 20 characters'
        echo 'and the valid characters are digits (0~9) and letters (A~Z, a~z, case sensitive)'
        return 1
    fi
    if ! [[ $regConfirm = $regPassword ]]; then 
        echo 'Password and its confirmation mismatch, please try again'
        return 1
    fi
    return 0
}

while : ; do 
    read -p 'Student ID: ' studentID
    validateStudentID && break
done

while : ; do 
    read -p 'Password (hidden): ' -s regPassword
    echo
    read -p 'Password Confirmation(hidden): ' -s regConfirm
    echo
    validatePassword && break
done

echo "Your user name will be stu${studentID}"
echo "${studentID}" > ./log.${studentAddress}
echo "${studentID},`echo ${regPassword} | base64`,${studentAddress}" >> ./tester-info.csv
