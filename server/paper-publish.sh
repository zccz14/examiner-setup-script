#!/usr/bin/env bash


# load config
source ../config/server-network.conf

# publish html page
cat << EOF > /var/www/exam/paper.html
<!doctype html>
<html>
<head>
  <title>Paper</title>
</head>
<body>
`awk -f ./paper-process.awk ../config/server-paper.conf`
</body>
</head>

EOF

# publish raw page
cp ../config/server-paper.conf /var/www/exam/paper.txt
