#!/usr/bin/env bash

# load configurations
source ../config/client-network.conf

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

function uploadFile() {
	name=$1; pass=$2; file_to_upload=$3;
	curl -sST $file_to_upload ftp://$CLI_FTP_HOST --user $name:$pass
	ftp_error=$?
	case "$ftp_error" in
		[0] )
			echo success
			return 0 ;;
		[7] )
			echo FTP server is not open currently, please wait for a while ;;
		[67] )
			echo Permission error, maybe your have used up file quota \
			    or the service is unavailable currently ;;
	esac
	return 1
}

function downloadPaper(){
	echo downloading test paper
	curl -sSf http://$CLI_HTTP_HOST/paper.txt -o ./paper/paper.txt 
	if [[ $? -gt 0 ]]; then
		rm -rf ./paper
		echo failed to download test paper, maybe the paper has not been published
		exit 1
	fi
}

function updateAnswer() {
	ind=$1; sel=$2
	touch paper/answer
	# bash pipe will truncate the file before the execution
	awk 'BEGIN{i=1}{ans[i++]=$0;}END{ans['$ind']="'$sel'";for(i=1;i<='$totalCount';i++) print ans[i];}' \
	  paper/answer > paper/answer_tmp
	mv paper/answer_tmp paper/answer
}

function printQuestion(){
	echo 
	cat ./paper/q-$currentCount
}

function selectAnswer(){
	ans=$1
	echo Select $ans for question $currentCount
	updateAnswer $currentCount $ans
	if [[ $currentCount -lt $totalCount ]]; then 
		currentCount=$(($currentCount + 1))
		printQuestion
	else
		echo This is the end of the exam, press O to check answer status
	fi
}

function submitAnswer(){
	answerOverview
	answered=`cat paper/answer | wc -w`
	if [[ $answered -lt $totalCount ]]; then
		echo You still have unanswered questions, please finish them before submission.
		return
	fi
	read -n1 -p "submit answer? [yN]" ch
	echo 
	if [[ $ch != 'y' ]]; then 
		return
	fi

	while true; do
		read -p "enter user name (stu+StuID): " name
		read -sp "enter password (hidden): " pass
		echo 
		cat paper/answer | tr -d '\n' > "paper/$name"
		uploadFile $name $pass "paper/$name"
		if [[ $? -eq 0 ]]; then 
			rm -rf paper
			exit 0
		fi
	done
}

function answerOverview() {
	echo 
	echo '_____________ Answer Overview _____________'
	awk 'BEGIN{i=1}{ans[i++]=$0;}END{for(i=1;i<='$totalCount';i++) printf(" %2d: %4s %c", i, ans[i]?ans[i]:"_", i%4==0?"\n":"|");}' paper/answer
	echo Answered: `cat paper/answer | wc -w`/$totalCount
	echo 
}

function getOption() {
	read -sn1 ch 
	case $ch in
		[Aa] )
			selectAnswer A ;;
		[Bb] )
			selectAnswer B ;;
		[Cc] )
			selectAnswer C ;;
		[Dd] )
			selectAnswer D ;;
		[Ee] )
			selectAnswer E ;;
		[Ff] )
			selectAnswer F ;;
		[Gg] )
			selectAnswer G ;;
		[Hh] )
			echo "$help" ;;
		[Qq] )
			read -p 'enter question number: ' num
			if [[ $num -ge 1 ]] && [[ $num -le 20 ]]; then
				currentCount=$num
				printQuestion
			else
				echo \"$num\" is not an invalid question number
			fi
			;;
		[Pp] )
			if [[ $currentCount -eq 1 ]]; then
				echo This is the first question.
			else
				currentCount=$(($currentCount - 1))
				printQuestion
			fi ;;
		[Nn] )
			if [[ $currentCount -eq $totalCount ]]; then
				echo This is the last question.
			else
				currentCount=$(($currentCount + 1))
				printQuestion
			fi ;;
		[Oo] )
			answerOverview;;
		[Ss] )
			submitAnswer;;
		[Xx] )
			echo Bye~ 
			rm -rf paper
			exit 0 
			;;
		* )
			echo "Please enter an valid option, press H for help";
	esac
}

# Main process
mkdir -p ./paper
downloadPaper
awk -f ./paper-process.awk ./paper/paper.txt 
totalCount=`cat ./paper/paper-total-count`
currentCount=1
updateAnswer

clear
printQuestion
while true; do
	getOption
done