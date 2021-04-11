# RHCSA_ENV
![RHCSA](https://img.shields.io/badge/-RHCSA-EE0000?style=for-the-badge&logo=Red%20Hat&logoColor=white)
![Vagrant](https://img.shields.io/badge/-Vagrant-1563FF?style=for-the-badge&logo=Vagrant&logoColor=white)

An environment to prepare for the RHCSA certification, mainly automates server side installation of samba and NFS (RHCSA deals only with the client side)

### How to use:

`vagrant up` will bring three machines `controller`, `share_1` and `share_2`

Details for these machines are as follows:

| Machine name |   IP address   |   FQDN   |
|:------------:|:--------------:|:--------:|
|  controller  | 192.168.50.210 |          |
|    share_1   | 192.168.50.211 |  nfs.com |
|    share_2   | 192.168.50.212 | cifs.com |

after the machines are up and running do `vagrant ssh controller` and from there start practicing.

SSH keys have already been generated on the controller so from the controller you can ssh into any of the 2 machines using

```bash
ssh cifs.com

ssh nfs.com
```

---

#### showing NFS shares 

`showmount -e nfs.com` OR `showmount -e cifs.com`

#### showing samba shares 

`smbclient -U cifs //cifs.com/cifs` OR `smbclient -U cifs //nfs.com/cifs`

*password is **cifs**
