#!/bin/bash
yum update 

echo "[TASK 1] Installing NFS and SMB for File sharing"
yum install -y nfs-utils cifs-utils samba-client samba

echo "[TASK 2] Allow NFS and SMB services through firewall"
systemctl enable --now {nfs-server,smb,firewalld}
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload

echo "[TASK 3] Configure NFS"
mkdir -v /nfs && touch /nfs/nfs_file
echo "NFS shares" > /nfs/nfs_file
echo "/nfs   *(rw,no_root_squash)" >> /etc/exports
systemctl restart nfs-server

echo "[TASK 4] Configure Samba"
mkdir -v /cifs && touch  /cifs/cifs_file 
echo "Samba shares" > /cifs/cifs_file
useradd cifs
echo cifs | passwd --stdin cifs # set password of user cifs to cifs
printf "cifs\ncifs\n" | smbpasswd -a -s cifs # [1] set samba shares password
chown cifs /cifs && sudo chmod 770 /cifs
cat >>/etc/samba/smb.conf<<EOF
[cifs]
comment = samba share 
path = /cifs 
read only = No
EOF

echo "[TASK 5] Add SELinux label to Samba directory"
setsebool -P samba_enable_home_dirs on
semanage fcontext -a -t samba_share_t "/cifs(/.*)?"
restorecon -irv /cifs