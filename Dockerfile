# vim:set ft=dockerfile

# Base image: Ubuntu 22.04 LTS (Jammy Jellyfish)
# Using phusion/baseimage for better init system and SSH support
FROM phusion/baseimage:jammy-1.0.0

# Set environment variable for sudoers file path
ENV SUDOFILE /etc/sudoers

# Copy the script to change user UID
COPY change_user_uid.sh /

# Update system and install Ansible, sudo, and SSH
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
    # Set up SSH directory for vagrant user
    mkdir -p /home/vagrant/.ssh && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    # Configure sudo access without password for sudo group
    chmod u+w ${SUDOFILE} && \
    echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE} && \
    chmod u-w ${SUDOFILE}

# Copy Ansible playbook files
COPY provisioning/ provisioning

# Run Ansible playbook to set up the environment
RUN ansible-playbook provisioning/site.yml -c local

# Make the UID change script executable
RUN chmod +x /change_user_uid.sh

# Set the entry point to run the UID change script
ENTRYPOINT /change_user_uid.sh

# Default command to run on container start
CMD ["/sbin/my_init"]
