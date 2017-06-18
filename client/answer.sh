#!/usr/bin/env bash

help=`cat << EOF
* A-G: Select an answer
* H: Help Message
* Q: Select question
* N: Next question
* P: Previous question
* O: Status overview
* S: Submit answer
* X: Quit
EOF`

function getOption() {
	read -sn1 ch 
	case $ch in
		[Aa] )
			echo select A ;;
		[Bb] )
			echo select B ;;
		[Cc] )
			echo select C ;;
		[Dd] )
			echo select D ;;
		[Ee] )
			echo select E ;;
		[Ff] )
			echo select F ;;
		[Gg] )
			echo select G ;;
		[Hh] )
			echo "$help" ;;
		[Qq] )
			read -p 'enter question number: ' num
			echo select $num ;;
		[Nn] )
			echo select next ;;
		[Pp] )
			echo select previous ;;
		[Ss] )
			echo submit answer? [yN];;
		[Xx] )
			echo Bye~ ;;
		* )
			echo "Please enter an valid option, press H for help";
	esac
}

function uploadFile() {
	name=$1; pass=$2; file_to_upload=$3;
	curl -T $file_to_upload ftp://ftp.test-examination.edu --user $name:$pass
	ftp_error=$?
	case "$ftp_error" in
		[0] )
			echo success ;;
		[7] )
			echo FTP server is not open currently, please wait for a while ;;
		[67] )
			echo Permission error, maybe your have used up file quota ;;
	esac
}

while true; do
	getOption
done