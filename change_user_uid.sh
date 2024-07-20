#!/bin/bash

# if needed, we change the uid of the vagrant user
# so that to be sure it matches the one of the host
# this way, changing a file from within the container
# does not alter ownership
if ! [ $(id -u vagrant) = $HOST_USER_UID ]; then
    usermod -u $HOST_USER_UID vagrant
fi
if ! [ $(id -g vagrant) = $HOST_USER_GID ]; then
    groupmod -g $HOST_USER_GID vagrant
fi
if  test -z "$@" ; then
    /sbin/my_init
else
    exec "$@"
fi
