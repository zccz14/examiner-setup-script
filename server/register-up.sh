#!/usr/bin/env bash

# load config
source ../config/server-network.conf

userdel -f student
rm -rf ../run/register

# working directory
mkdir -p ../run/register
chmod 755 ../run/register
touch ../run/register/tester-info.csv
# suppress all kinds of login messages
touch ../run/register/.hushlogin
echo > ../run/register/tester-ingo.csv
# other can only attach data
chmod 662 ../run/register/tester-info.csv

# register login shell
grep -qF `realpath ./register-main.sh` /etc/shells
if [ $? -gt 0 ]; then 
    cp /etc/shells /etc/shells.backup
    echo `realpath ./register-main.sh` >> /etc/shells
fi
useradd -d `realpath ../run/register` -s `realpath ./register-main.sh` student
echo student:student | sudo chpasswd
chown student ../run/register
