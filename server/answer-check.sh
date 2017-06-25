#!/usr/bin/env bash

source ../config/server-answer.conf

answer=`echo $EXAM_ANSWER | sed -e 's/\s//g'`

function calcScore(){
  paper=$1
  answerSep=`echo $answer | sed -e 's/[A-Z]/\0 /g'`
  paperSep=`echo $paper | sed -e 's/\s//g' | sed -e 's/[A-Z]/\0 /g'`
  count=`echo $answer | tr -d '\n' | wc -c`
  rightCount=0
  for (( i = 1; i <= $count; i++ )); do
    exp=`echo $answerSep | cut -d ' ' -f$i`
    act=`echo $paperSep | cut -d ' ' -f$i`
    if [[ "$act" = "$exp" ]]; then
      rightCount=$(($rightCount + 1))
    fi
  done
  echo $((100 * $rightCount / $count))
}

rm -f ../run/ans.csv

# Process each register entry
for item in `cat ../run/register/tester-info.csv`; do
  name=`echo $item | cut -d, -f1`
  pass=`echo $item | cut -d, -f2 | base64 -d`
  addr=`echo $item | cut -d, -f3`

  # User Name
  user_name=stu$name
  ans_file="../run/answer/$user_name/$user_name"
  score=0
  if ! [[ -e $ans_file ]]; then
    echo $user_name has no submitted answer
  else
    ans=`cat $ans_file`
    score=`calcScore $ans`
  fi
  echo stu$item,$score >> ../run/ans.csv
done

cp ../run/ans.csv /var/www/exam/cgi-bin/ans.csv
