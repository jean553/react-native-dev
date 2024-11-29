# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab :

# This Vagrantfile sets up a development environment for a React Native project

# Project name, used for naming the Docker container
PROJECT = "react_native_dev_example"

# Determine the host's IP address for React Native packager
# This is used to allow the mobile device to connect to the dev server
REACT_NATIVE_PACKAGER_HOSTNAME = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

# Disable parallel execution of Vagrant commands
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

# Set Docker as the default provider for Vagrant
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure(2) do |config|
  # Disable automatic key insertion
  config.ssh.insert_key = false

  # Define the main development VM
  config.vm.define "dev", primary: true do |app|
    app.vm.provider "docker" do |d|
      # Use a custom Docker image for React Native development
      # This image is defined in the Dockerfile: ./Dockerfile
      d.image = "jean553/react-native-dev"
      d.name = "#{PROJECT}_dev"
      d.has_ssh = true
      # Pass the host user's UID to the container for file permission matching
      d.env = {
        "HOST_USER_UID" => Process.euid,
      }
    end
    # Set the SSH username for Vagrant
    app.ssh.username = "vagrant"
  end

  # Port forwarding for React Native development server
  # These ports are used by the React Native packager and dev tools
  # They correspond to the default ports used in the React Native source code
  config.vm.network "forwarded_port", guest: 19000, host: 19000
  config.vm.network "forwarded_port", guest: 19001, host: 19001
  config.vm.network "forwarded_port", guest: 19002, host: 19002

  # Provision the VM with the host's IP address for React Native packager
  # This is used in the React Native app's configuration to connect to the dev server
  config.vm.provision "set_lan_ip", "type": "shell" do |installs|
    installs.inline = "
      echo 'export REACT_NATIVE_PACKAGER_HOSTNAME=#{REACT_NATIVE_PACKAGER_HOSTNAME}' >> /home/vagrant/.zshrc
    "
  end
end
