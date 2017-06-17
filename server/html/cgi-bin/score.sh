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

if [ $REQUEST_METHOD -eq 'POST' ]; then
  # read post content from standard input
  read POST_STRING
  addr=REMOTE_ADDR
fi

echo '<div class="result">'
if [ "$score" = "" ]; then 
  echo 'enter your login name (stu + student ID) and password'
  echo $error_msg
else 
  echo 'your score is: ' $score
fi
echo '</div>'

# Footer Section
cat << EOF
  </body>
</html>
EOF

