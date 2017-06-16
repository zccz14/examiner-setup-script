#!/usr/bin/env bash

# load configurations
source ../config/client-network.conf

# let the DNS configuration set by resolve.conf
# original configuration is backed-up as NetworkManager.conf.backup
sed -i.backup -e 's/dns=\w\+/dns=none/' /etc/NetworkManager/NetworkManager.conf
# stop the original DNS service managed by systemd-resolved
systemctl stop systemd-resolved.service

sed -i.backup -e 's/^nameserver.*$/nameserver '${CLI_DNS_SERVER}'/' /etc/resolve.conf

