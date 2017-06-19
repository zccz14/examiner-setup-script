#!/usr/bin/env bash

./paper-publish.sh
echo "cd `realpath .` && `realpath ./config-ftp.sh`" | at now + 20 minutes
echo "service vsftpd stop" | at now + 40 minutes
echo "cd `realpath .` && `realpath ./answer-check.sh`" | at now + 43 minutes