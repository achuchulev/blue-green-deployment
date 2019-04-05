  Vagrant.configure("2") do |config|
    config.vm.box = "achuchulev/bionic64"
    config.vm.box_version = "0.0.1"
    config.vm.synced_folder ".", "/vagrant", disabled: false
    #config.vm.network "forwarded_port", guest: 80, host: 2368
    config.vm.network "private_network", ip: "192.168.0.10"
    config.vm.provision "shell", path: "scripts/nginx_config.sh", privileged: "false"
  end
