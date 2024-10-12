# vim:set ft=dockerfile

# Base image selection
# We use phusion/baseimage:jammy-1.0.0 as it provides a minimal Ubuntu-based image
# Note: As of July 2023, using noble (24.04 LTS) causes issues with user permissions
FROM phusion/baseimage:jammy-1.0.0

# Set environment variable for sudoers file location
ENV SUDOFILE /etc/sudoers

# Copy the script to change user UID
COPY change_user_uid.sh /

# Update system and install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install ansible sudo ssh -y

# Configure SSH for Vagrant usage
RUN \
    # Enable SSH
    rm -f /etc/service/sshd/down && \
    # Allow empty passwords and password authentication
    echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    # Create 'vagrant' user with appropriate settings
    useradd \
        --shell /bin/zsh \
        --create-home --base-dir /home \
        --user-group \
        --groups sudo,_ssh \
        --password '' \
        vagrant && \
    # Set up SSH directory for 'vagrant' user
    mkdir -p /home/vagrant/.ssh && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    # Configure sudo access for the 'sudo' group
    chmod u+w ${SUDOFILE} && \
    echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE} && \
    chmod u-w ${SUDOFILE}

# Copy provisioning files and run Ansible playbook
COPY provisioning/ provisioning
RUN ansible-playbook provisioning/site.yml -c local

# Make the UID change script executable
RUN chmod +x /change_user_uid.sh

# Set the entry point to the UID change script
ENTRYPOINT /change_user_uid.sh

# Set the default command to start the init system
CMD ["/sbin/my_init"]
