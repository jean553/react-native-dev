# react-native-dev

A Vagrant/Docker ready project for React Native development.

## Build the container

```sh
vagrant up
```

## Connect to the container

```sh
vagrant ssh
```

## Create your project

```sh
expo init MyProject
```

## Start your project

Into your new project directory:

```sh
npm start
```

## Run your app with Expo

Install Expo on your mobile from [here](https://play.google.com/store/apps/details?id=host.exp.exponent).

Open Expo and click on `Scan QR code`. Scan your server QR code.

You're ready to go.

## Monitoring / Debugging

Open `localhost:19002` on your browser in order to render the Expo Developer Tools interface.

## Using it with Vagrant

```ruby

# get your local IP address
REACT_NATIVE_PACKAGER_HOSTNAME = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

...

config.ssh.insert_key = false
config.vm.define "dev", primary: true do |app|
  app.vm.provider "docker" do |d|
    d.image = "jean553/react-native-dev"
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

config.vm.provision "set_lan_ip", "type": "shell", privileged: false do |installs|
  installs.inline = "


    # ensure Expo looks for your host IP address into your LAN
    cd /vagrant/#{PROJECT_NAME}
    echo 'export REACT_NATIVE_PACKAGER_HOSTNAME=#{REACT_NATIVE_PACKAGER_HOSTNAME} npm start  && cd /vagrant/#{PROJECT_NAME}' | sudo tee --append /home/vagrant/.zshrc

    # add dependencies here
    yarn add native-base --save
    yarn add react-navigation
  "
end
```
