#!/usr/bin/env bash

# load config
source ../config/server-network.conf

# delete register account to disable register
userdel -f student

# remove register entry
grep -qF `realpath ./register-main.sh` /etc/shells
if [ $? -eq 0 ]; then
  grep -vF `realpath ./register-main.sh` /etc/shells > '/tmp/shells.tmp'
  cat '/tmp/shells.tmp' > /etc/shells
  rm '/tmp/shells.tmp'
fi