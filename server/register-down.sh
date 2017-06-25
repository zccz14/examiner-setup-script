#!/usr/bin/env bash

# delete register account to disable register
userdel -f student

# remove register entry
grep -v '^#' /etc/shells | grep -qF `realpath ./register-main.sh` 
if [ $? -eq 0 ]; then
  grep -vF `realpath ./register-main.sh` /etc/shells > '/tmp/shells.tmp'
  cat '/tmp/shells.tmp' > /etc/shells
  rm '/tmp/shells.tmp'
fi