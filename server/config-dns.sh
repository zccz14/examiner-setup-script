#!/usr/bin/env bash

# default configuration, can be overwritten by configuration file
bindConfFile='/etc/bind/named.conf.local'
zoneFileDir='/etc/bind/zones'
SRV_DNS_ZONE='example.com'
networkDeviceName=`ifconfig | grep -o --color=none '^en\w*\b'`
serverInetAddr=`ifconfig ${networkDeviceName} | grep -oE 'inet addr:[0-9.]+' | cut -d: -f2`

# load config
source ../config/server-network.conf

zoneFileName="${zoneFileDir}/db.${SRV_DNS_ZONE}"

# Add local configure entry
cp ${bindConfFile} ${bindConfFile}.backup
echo ${bindConfFile}
cat << EOF >> ${bindConfFile}
zone "${SRV_DNS_ZONE}" {
  type master;
  file "${zoneFileName}";
};
EOF

# Check configuration syntax
named-checkconf

# Add forwarding zone record
mkdir -p ${zoneFileDir}
cat << EOF > ${zoneFileName}
\$TTL 	604800
@       IN      SOA     ns.${SRV_DNS_ZONE}. admin.${SRV_DNS_ZONE}. (
                  3     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL
;
; name servers - NS records
     IN      NS      ns.${SRV_DNS_ZONE}.

; name servers - A records
ns.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}

; web, FTP, reg services address
www.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}
ftp.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}
reg.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}
EOF

# Check zone configuration
named-checkzone ${SRV_DNS_ZONE} ${zoneFileName}

# restart the bind9 daemon to apply the configuration
systemctl restart bind9

# Test the DNS service
function tryResolve() {
  # map parameters
  addr=$1; dns=$2
  if [[ `dig @${dns} ${addr} +short | wc -l` -gt 0 ]]; then 
    echo resvole ${addr} as `dig @${dns} ${addr} +short`
    return 0
  else 
    echo cannot resolve ${addr}
    return 1
  fi	
}

# Validate the configuration
tryResolve reg.test-examination.edu $serverInetAddr
tryResolve ftp.test-examination.edu $serverInetAddr
tryResolve ns.test-examination.edu $serverInetAddr
tryResolve www.test-examination.edu $serverInetAddr