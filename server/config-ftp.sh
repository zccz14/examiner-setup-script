#!/use/bin/env bash

# Create tester group 
groupadd -f tester

# Check disk quota (using quotatool)
if [ `grep '^[^#]' /etc/fstab | awk '{if($2=="/")print $4}' | grep -q quota` -gt 0 ]; then 
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
if [ $? -gt 0 ]; then 
    [ -e /etc/shells.backup ] || cp /etc/shells /etc/shells.backup
    echo '/bin/false' >> /etc/shells
fi

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
   chmod 662 user_home
   touch user_home/.hushlogin

   userdel -f $user_name
   useradd -d `realpath ../run` -s '/bin/false' $user_name
   quotatool -u $user_name -i -q2 -l2 -b -q10 -l10 /
   echo $user_name >> ../run/ftp_userlist
done

# Startup FTP server
[ -e /etc/vsftpd.conf ] || cp /etc/vsftpd.conf /etc/vsftpd.conf.backup
cat > /etc/vsftpd.conf << FTP_EOF
listen=NO
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
user_sub_token=$USER
local_root=`realpath ../run/answer`/$USER
userlist_enable=YES
userlist_file=`realpath ../run/ftp_userlist`
userlist_deny=NO
FTP_EOF

service ftpd reload