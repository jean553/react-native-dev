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
