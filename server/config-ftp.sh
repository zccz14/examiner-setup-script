#!/usr/bin/env bash

# Create tester group 
groupadd -f tester

# Check disk quota (using quotatool)
grep '^[^#]' /etc/fstab | awk '{if($2=="/")print $4}' | grep -q quota
if [[ $? -gt 0 ]]; then 
  # no quota enabled for root partition
  # add quota option
  sed -i.backup -e \
    '/^[^#]\S\+\s\+\/\s/s/\(\(\S\+\s\+\)\{3\}\S\+\)\(\(\s\+\S\+\)\{2\}\)/\1,grpquota,usrquota\3/g' \
    /etc/fstab 
  mount -o remount /
  quotacheck -mug /
  quotaon -ug /
fi


# Prepare user answer folder
rm -rf ../run/answer
mkdir -p ../run/answer
chmod 755 ../run/answer

# Prepare login shell (false) to prevent unintented remote access
grep -qF '/etc/false' /etc/shells
if [[ $? -gt 0 ]]; then 
  [ -e /etc/shells.backup ] || cp /etc/shells /etc/shells.backup
  echo '/bin/false' >> /etc/shells
fi

# Prepare access list
grep -v '^#' /etc/pam.d/vsftpd | grep -q 'account\s\+required\s\+pam_access\.so'
if [[ $? -gt 0 ]]; then
  [[ -e /etc/pam.d/vsftpd.backup ]] || cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.backup
  echo 'account  required  pam_access.so' >> /etc/pam.d/vsftpd
fi
[[ -e /etc/security/access.conf.backup ]] || cp /etc/security/access.conf /etc/security/access.conf.backup
echo > /etc/security/access.conf

# Clear user list
rm -f ../run/ftp_userlist

# Process each register entry
for item in `cat ../run/register/tester-info.csv`; do
  name=`echo $item | cut -d, -f1`
  pass=`echo $item | cut -d, -f2 | base64 -d`
  addr=`echo $item | cut -d, -f3`

  # User Name
  user_name=stu$name

  # Home directory
  mkdir -p ../run/answer/$user_name
  user_home=`realpath ../run/answer/$user_name`
  chmod 755 $user_home
  touch ${user_home}/.hushlogin

  userdel -f $user_name
  useradd -g tester -d $user_home -s '/bin/false' $user_name
  echo $user_name:$pass | chpasswd
  chown $user_name:tester "$user_home"
  # quota set to 3 with an extra one for home folder inode
  quotatool -u $user_name -i -q3 -l3 -b -q20 -l20 /
  # access control
  echo "-:$user_name:ALL EXCEPT $addr" >> /etc/security/access.conf
  echo $user_name >> ../run/ftp_userlist
done

# Startup FTP server
[[ -e /etc/vsftpd.conf.backup ]] || cp /etc/vsftpd.conf /etc/vsftpd.conf.backup
cat > /etc/vsftpd.conf << FTP_EOF
listen=YES
anonymous_enable=NO
local_enable=YES
# Default umask for local users is 077. You may wish to change this to 022,
# if your users expect that (022 is used by most other ftpd's)
#local_umask=022
use_localtime=YES
connect_from_port_20=YES
idle_session_timeout=600
data_connection_timeout=120
ftpd_banner=Welcome to blah FTP service.
chroot_local_user=YES
write_enable=YES
user_sub_token=\$USER
local_root=`realpath ../run/answer`/\$USER
allow_writeable_chroot=YES
userlist_enable=YES
userlist_file=`realpath ../run/ftp_userlist`
userlist_deny=NO
pam_service_name=vsftpd
FTP_EOF

sudo service vsftpd restart
