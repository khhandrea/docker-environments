#!/bin/bash

USER_ID=${HOST_UID:-999}
GROUP_ID=${HOST_UID:-999}
USER_PASSWORD=ubuntu

# Force change the UID and GID of 'user' to match the host
groupmod -o -g "$GROUP_ID" user
usermod -o -u "$USER_ID" -g "$GROUP_ID" user
echo "user:$USER_PASSWORD" | chpasswd

chown -R user:user /home/user

# Switch to user
exec gosu user "$@"