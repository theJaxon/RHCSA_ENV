# RHCSA_ENV
An environment to prepare for the RHCSA certification, mainly automates server side installation of samba and NFS (RHCSA deals only with the client side)

### How to use:

`vagrant up` will bring three machines:

1- controller 

2- share_1

3- share_2

after the machines are up and running do `vagrant ssh controller` and from there start practicing.
ex: showing NFS shares 

`showmount -e nfs.com` OR `showmount -e cifs.com`

ex: showing samba shares 

`smbclient -U cifs //cifs.com/cifs`

*password is **cifs**

 To ssh into the machines use 
`ssh vagrant@nfs.com` OR `ssh vagrant@cifs.com` 

*password is **vagrant**

