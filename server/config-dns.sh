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
echo << EOF >> ${bindConfFile}
zone "${SRV_DNS_ZONE}" {
	type master;
	file "${zoneFileName}";
}
EOF

# Check configuration syntax
named-checkconf

# Add forwarding zone record
mkdir -p ${zoneFileDir}
echo << EOF >> ${zoneFileName}
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
ns1.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}

; web, FTP, reg services address
www.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}
ftp.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}
reg.${SRV_DNS_ZONE}.	IN	A	${serverInetAddr}
EOF

# Check zone configuration
named-checkzone ${SRV_DNS_ZONE} ${zoneFileName}

sudo systemctl restart bind9

# Test the DNS service
if ! [ `dig @localhost www.${SRV_DNS_ZONE} +short | wc -l` -eq 0 ]; then 
	echo 'cannot resolve web host'
fi
if ! [ `dig @localhost ftp.${SRV_DNS_ZONE} +short | wc -l` -eq 0 ]; then 
	echo 'cannot resolve ftp host'
fi
if ! [ `dig @localhost reg.${SRV_DNS_ZONE} +short | wc -l` -eq 0 ]; then 
	echo 'cannot resolve reg host'
fi