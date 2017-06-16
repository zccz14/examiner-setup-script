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
done

# Startup FTP server





