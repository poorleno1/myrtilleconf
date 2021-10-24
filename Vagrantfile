Vagrant.configure("2") do |config|
  config.vm.define "gw" do |gw|
	  gw.vm.box = "jarekole/2019_gui"
	  gw.vm.hostname = "gw"
	  #gw.vm.network "private_network", ip: "192.168.33.10"
	  #gw.vm.network = "internal_switch"
	  gw.vm.synced_folder ".", "/vagrant", disabled: true
	  gw.winrm.transport = :plaintext
      gw.winrm.basic_auth_only = true
	
	  gw.vm.provider "hyperv" do |h|
		h.enable_virtualization_extensions = true
		h.linked_clone = true
	  end
	  gw.vm.provision "shell", path: "myrtilleconf/myrtille.ps1", privileged: true
	  gw.vm.provision "reload"
	  gw.vm.provision "reload"
	  gw.vm.provision "shell", path: "myrtilleconf/myrtille.ps1", privileged: true
	  gw.vm.provision "reload"
	end
end


Vagrant.configure("2") do |config|
  config.vm.define "sh1" do |sh1|
	  sh1.vm.box = "jarekole/2019_gui"
	  sh1.vm.hostname = "sh1"
	  #sh1.vm.network "private_network", ip: "192.168.33.10"
	  #sh1.vm.network = "internal_switch"
	  sh1.vm.synced_folder ".", "/vagrant", disabled: true
	  sh1.winrm.transport = :plaintext
      sh1.winrm.basic_auth_only = true
	
	  sh1.vm.provider "hyperv" do |h|
		h.enable_virtualization_extensions = true
		h.linked_clone = true
	  end
	  sh1.vm.provision "shell", path: "myrtilleconf/myrtille_sh.ps1", privileged: true
	  sh1.vm.provision "reload"
	end
end