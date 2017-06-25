#!/usr/bin/env bash

# disable default site
[[ -e /etc/apache2/sites-enabled/000-default.conf ]] && a2dissite 000-default.conf
[[ -e /etc/apache2/sites-enabled/100-exam.conf ]] && a2dissite 100-exam.conf

# create exam site
rm -rf /var/www/exam
mkdir /var/www/exam
cp -r ./html/* /var/www/exam/
chown -Rf root:root /var/www/exam
cp ./100-exam.conf /etc/apache2/sites-available/
a2ensite 100-exam.conf

# Enable CGI
[[ -e /etc/apache2/mods-enabled/cgi.load ]] || a2enmod cgi

service apache2 reload 
