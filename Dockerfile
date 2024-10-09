# vim:set ft=dockerfile

# Base image selection
# on July 2024, switching to noble (24.04 LTS) causes issues
# because it will mount the volume on "vagrant up" with default user "ubuntu"
# instead of the expected one "vagrant"
#
# this cause rights and privileges issues for all commands coming after
FROM phusion/baseimage:jammy-1.0.0

# Set environment variable for sudoers file
ENV SUDOFILE /etc/sudoers

# Copy script to change user UID
COPY change_user_uid.sh /

# Update system and install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install ansible sudo ssh -y

# Configure SSH for Vagrant usage
RUN \
    # Enable SSH service
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
    # Configure sudo access for vagrant user
    chmod u+w ${SUDOFILE} && \
    echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> ${SUDOFILE} && \
    chmod u-w ${SUDOFILE}

# Copy provisioning files and run Ansible playbook
COPY provisioning/ provisioning
RUN ansible-playbook provisioning/site.yml -c local

# Set execute permissions for the UID change script
RUN chmod +x /change_user_uid.sh

# Set the entrypoint to run the UID change script
ENTRYPOINT /change_user_uid.sh

# Set the default command to run on container start
CMD ["/sbin/my_init"]
