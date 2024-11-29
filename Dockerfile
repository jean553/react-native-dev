# vim:set ft=dockerfile

# This Dockerfile sets up a development environment for React Native

# Base image selection
# Using Ubuntu 22.04 LTS (Jammy) for stability
# Note: Upgrading to Ubuntu 24.04 (Noble) causes user-related issues
FROM phusion/baseimage:jammy-1.0.0

# Define sudo file path for later use
ENV SUDOFILE /etc/sudoers

# Copy the UID change script into the container
# This script is used to match the container user's UID with the host user's UID
COPY change_user_uid.sh /

# Install essential tools:
# - ansible: for provisioning the container
# - sudo: for privilege escalation
# - ssh: for Vagrant to connect to the container
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install ansible sudo ssh -y

# Configure SSH for Vagrant usage
# This setup allows Vagrant to connect to the container as if it were a VM
RUN \
    rm -f /etc/service/sshd/down && \
    echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    useradd \
        --shell /bin/zsh \
        --create-home --base-dir /home \
        --user-group \
        --groups sudo,_ssh \
        --password '' \
        vagrant && \
    mkdir -p /home/vagrant/.ssh && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    chmod u+w ${SUDOFILE} && \
    echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE} && \
    chmod u-w ${SUDOFILE}

# Copy and run Ansible provisioning scripts
# These scripts set up the React Native development environment
# They are located in the ./provisioning directory of the project
COPY provisioning/ provisioning
RUN ansible-playbook provisioning/site.yml -c local

# Set up the entrypoint script
# This script adjusts the container user's UID to match the host user's UID
RUN chmod +x /change_user_uid.sh
ENTRYPOINT /change_user_uid.sh

# Set the default command to run when the container starts
CMD ["/sbin/my_init"]
