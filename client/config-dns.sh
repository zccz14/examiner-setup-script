
# let the DNS configuration set by resolve.conf
# original configuration is backed-up as NetworkManager.conf.backup
sudo sed -i.backup -e 's/dns=\w\+/dns=none/' /etc/NetworkManager/NetworkManager.conf