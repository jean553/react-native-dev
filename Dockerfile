# vim:set ft=dockerfile

# Use Ubuntu 22.04 LTS (Jammy) as the base image
# Note: Using noble (24.04 LTS) causes issues with user mounting
FROM phusion/baseimage:jammy-1.0.0

# Set the path for the sudoers file
ENV SUDOFILE /etc/sudoers

# Copy the script to change user UID
# This script is used in the ENTRYPOINT to ensure correct file permissions
COPY change_user_uid.sh /

# Install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install ansible sudo ssh -y

# Configure SSH for Vagrant usage
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

# Copy Ansible provisioning files
# These files set up the development environment for React Native
COPY provisioning/ provisioning

# Run Ansible playbook to set up the development environment
RUN ansible-playbook provisioning/site.yml -c local

# Make the UID change script executable
RUN chmod +x /change_user_uid.sh

# Set the entrypoint to run the UID change script
# This ensures that the container user has the same UID as the host user
ENTRYPOINT /change_user_uid.sh

# Set the default command to start the init system
CMD ["/sbin/my_init"]
