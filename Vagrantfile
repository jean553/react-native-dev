# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab :

# Define the project name
PROJECT = "react_native_dev_example"

# Get the IP address of the host machine for React Native packager
# This is used to set up network communication between the host and the container
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
      # Specify the Docker image to use
      # This image is defined in the Dockerfile: `Dockerfile`
      d.image = "jean553/react-native-dev"
      
      # Set the container name
      d.name = "#{PROJECT}_dev"
      
      # Enable SSH for this container
      d.has_ssh = true
      
      # Pass the host user's UID to the container
      # This is used in the entrypoint script: `change_user_uid.sh`
      d.env = {
        "HOST_USER_UID" => Process.euid,
      }
    end
    
    # Set the SSH username for Vagrant
    app.ssh.username = "vagrant"
  end

  # Forward necessary ports for React Native development
  # These ports are used by the React Native packager and development server
  config.vm.network "forwarded_port", guest: 19000, host: 19000
  config.vm.network "forwarded_port", guest: 19001, host: 19001
  config.vm.network "forwarded_port", guest: 19002, host: 19002

  # Provision the VM to set the LAN IP for React Native packager
  config.vm.provision "set_lan_ip", "type": "shell" do |installs|
    installs.inline = "
      echo 'export REACT_NATIVE_PACKAGER_HOSTNAME=#{REACT_NATIVE_PACKAGER_HOSTNAME}' >> /home/vagrant/.zshrc
    "
  end
end
