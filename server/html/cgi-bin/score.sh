#!/usr/bin/env bash

echo 'Content-type: text/html'
echo ''

# Header section
cat << EOF
<!doctype html>
<html lang=en>
  <head><title>Score</title></head>
  <body>
    <div>
      <h1>Score Query</h1>
      <hr />
    </div>
    <form method='post'>
      <label for='name'>Name:</label>
      <input required type='text' name='name' id='name'>
      <br>
      <label for='pass'>Password</label>
      <input required type='password' name='pass' id='pass'>
      <br>
      <input type='submit' value='query' />
      <input type='reset' value='reset' /
    </form>
EOF

score=""
error_msg=""


if [[ $REQUEST_METHOD = 'POST' ]]; then
  # read post content from standard input
  read POST_STRING
  addr=REMOTE_ADDR
  if [[ -e ans.csv ]]; then
    user=`echo $POST_STRING | sed 's/&/\n/g' | sed 's/=/ /' | awk '/user/{print $2}'`
    pass=`echo $POST_STRING | sed 's/&/\n/g' | sed 's/=/ /' | awk '/pass/{print $2}'`
    encPass=`echo $pass | base64`
    score=`cat ans.csv | grep -F "$user,$encPass,$REMOTE_ADDR," | cut -d , -f4`
    if [[ "$score" = "" ]]; then
      error_msg="username, password or IP address mismatch"
    fi
  else
    error_msg="score is not published"
  fi
fi

echo '<div class="result">'
if [ "$score" = "" ]; then 
  echo '<div>enter your login name (stu + student ID) and password</div>'
  echo '<div>'$error_msg'</div>'
else 
  echo "your score is: $score"
fi
echo '</div>'

# Footer Section
cat << EOF
  </body>
</html>
EOF

