# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab :

PROJECT = "react_native_dev_example"
REACT_NATIVE_PACKAGER_HOSTNAME = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
Vagrant.configure(2) do |config|

  config.ssh.insert_key = false
  config.vm.define "dev", primary: true do |app|
    app.vm.provider "docker" do |d|
      d.image = "react-native-dev"
      d.name = "#{PROJECT}_dev"
      d.has_ssh = true
      d.env = {
        "HOST_USER_UID" => Process.euid,
      }
    end
    app.ssh.username = "vagrant"
  end
  config.vm.network "forwarded_port", guest: 19000, host: 19000
  config.vm.network "forwarded_port", guest: 19001, host: 19001
  config.vm.network "forwarded_port", guest: 19002, host: 19002

  config.vm.provision "set_lan_ip", "type": "shell" do |installs|
    installs.inline = "
      echo 'export REACT_NATIVE_PACKAGER_HOSTNAME=#{REACT_NATIVE_PACKAGER_HOSTNAME}' >> /home/vagrant/.zshrc
    "
  end
end
