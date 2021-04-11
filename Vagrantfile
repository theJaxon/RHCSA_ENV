Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  config.vm.box_check_update = false
  config.vm.box = "bento/centos-8"

  (1..2).each do |i|
    config.vm.define "share-#{i}" do |share|
      share.vm.hostname = "share-#{i}"
      share.vm.network "private_network", ip: "192.168.50.#{i + 210}"

      # Create & attach a 5GiB disk to each share
      file_for_disk = "./large_disk#{i}.vdi"
      share.vm.provider "virtualbox" do |v|
        # If the disk already exists don't create it
        unless File.exist?(file_for_disk)
            v.customize ['createhd', '--filename', file_for_disk, '--size', 5120]
        end
        v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_for_disk]
      end
      share.vm.provision "shell", path: "share.sh"
    end
  end

  config.vm.define "controller" do |controller|
    controller.vm.hostname = "controller"
    controller.vm.network "private_network", ip: "192.168.50.210"
    controller.vm.provision "shell", path: "controller.sh"
  end
end

# [1] https://stackoverflow.com/questions/3323966/echo-smbpasswd-by-stdin-doesnt-work