#!/usr/bin/env bash

# update list and existing packages
sudo apt-get -qqy update
sudo apt-get -qqy dist-upgrade

# install packages
sudo apt-get -qqy install \
	bind9 bind9utils \
	quotatool \
	vsftpd \
	apache2
