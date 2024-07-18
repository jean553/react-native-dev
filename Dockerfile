# vim:set ft=dockerfile
FROM phusion/baseimage:noble-1.0.0

ENV SUDOFILE /etc/sudoers

COPY change_user_uid.sh /

# install ansible
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install ansible sudo ssh -y

# ssh configuration for Vagrant usage
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

# build the image using the ansible steps
COPY provisioning/ provisioning
RUN ansible-playbook provisioning/site.yml -c local

RUN chmod +x /change_user_uid.sh
ENTRYPOINT /change_user_uid.sh
CMD ["/sbin/my_init"]
