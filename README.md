# react-native-dev

A Vagrant/Docker environment for React Native development with Expo.

## Overview

This project provides a ready-to-use development environment for React Native using Vagrant and Docker. It simplifies the setup process and ensures a consistent development experience across different machines.

## Prerequisites

- Vagrant
- Docker
- (Optional) Expo mobile app for testing on a physical device

## Getting Started

### Build the Container

To set up your development environment, run:

### Connect to the Container

## Creating a New Project

## Running Your Project

## Using Expo

1. Install the Expo app on your mobile device from the [Google Play Store](https://play.google.com/store/apps/details?id=host.exp.exponent) or the Apple App Store.
2. Open the Expo app on your device.
3. Scan the QR code displayed in your terminal or in the Expo Developer Tools.

Your app should now run on your mobile device.

## Monitoring & Debugging

Access the Expo Developer Tools interface by opening `http://localhost:19002` in your web browser. This provides various debugging and monitoring options for your app.

## Project Structure

The project includes:

- `Dockerfile`: Defines the Docker image for the development environment.
- `Vagrantfile`: Configures the Vagrant setup and Docker provider.
- `provisioning/`: Contains Ansible playbooks for setting up the environment.

## Using it with Vagrant

The `Vagrantfile` includes configuration for setting up the development environment. It handles port forwarding, environment variables, and initial setup. Refer to the Vagrantfile for details on customization options.

## Contributing

Contributions to improve this development environment are welcome. Please feel free to submit issues or pull requests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
