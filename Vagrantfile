Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  config.vm.box_check_update = false

  config.vm.define "controller" do |controller|
    controller.vm.box = "bento/centos-8"
    controller.vm.hostname = "controller"
    controller.vm.network "private_network", ip: "192.168.50.210"
    controller.vm.provision "shell", inline: <<-SHELL
      sudo yum update 
      sudo yum install -y samba-client vdo kmod-kvdo httpd # Install samba, VDO and Apache web server
      sudo echo "192.168.50.211 nfs.com" >> /etc/hosts
      sudo echo "192.168.50.212 cifs.com" >> /etc/hosts
  SHELL
  end

  (1..2).each do |i|
    config.vm.define "share-#{i}" do |share|
      share.vm.box = "bento/centos-8"
      share.vm.hostname = "share-#{i}"
      share.vm.network "private_network", ip: "192.168.50.#{i + 210}"
      share.vm.provision "shell", inline:  <<-SHELL
      sudo echo "setenforce 1" >> /home/vagrant/.bashrc # Set SELinux to enforcing mode (by default on this box it's in permissive mode)
      sudo yum update 
      sudo yum install -y nfs-utils cifs-utils samba-client samba
      sudo systemctl enable --now {nfs-server,smb,firewalld}
      sudo firewall-cmd --permanent --add-service=nfs
      sudo firewall-cmd --permanent --add-service=mountd
      sudo firewall-cmd --permanent --add-service=rpc-bind
      sudo firewall-cmd --permanent --add-service=samba
      sudo firewall-cmd --reload
      sudo mkdir -v /nfs /cifs
      sudo touch /nfs/nfs_file  /cifs/cifs_file
      sudo echo "/nfs   *(rw,no_root_squash)" >> /etc/exports
      sudo systemctl restart nfs-server
      sudo useradd cifs
      echo cifs | passwd --stdin cifs # set password of user cifs to cifs
      printf "cifs\ncifs\n" | smbpasswd -a -s cifs # [1] set samba shares password
      sudo chown cifs /cifs && sudo chmod 770 /cifs
      sudo echo '''
                [cifs]
                  comment = samba share 
                  path = /cifs 
                  write list = samba
                ''' >> /etc/samba/smb.conf
      SHELL
    end
  end
end


# [1] https://stackoverflow.com/questions/3323966/echo-smbpasswd-by-stdin-doesnt-work