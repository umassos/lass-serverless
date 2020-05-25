Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provision "shell", path: "bootstrap.sh", privileged: false

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "customize_deployment.yml"
  end

  config.vm.provider "virtualbox" do |v|
    v.cpus = 4
    v.memory = 8192
  end
end
