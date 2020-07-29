Vagrant.configure("2") do |config|
  config.vm.define "centos-desktop"
  config.vm.box = "parasoft/centos8-desktop"

  config.vm.provider :virtualbox do |vb, override|
    vb.gui = true
    vb.linked_clone = true
    vb.memory = 4096

    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "VMSVGA"]
    vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    vb.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any" ]
    vb.customize ["setextradata", "global", "GUI/AutoresizeGuest", "on" ]
  end
end
