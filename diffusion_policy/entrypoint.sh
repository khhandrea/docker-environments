#!/bin/bash

USER_ID=${HOST_UID:-999}
GROUP_ID=${HOST_GID:-999}
USER_PASSWORD=ubuntu

# Force change the UID and GID of 'user' to match the host
groupmod -o -g "$GROUP_ID" user
usermod -o -u "$USER_ID" -g "$GROUP_ID" user
echo "user:$USER_PASSWORD" | chpasswd

chown -R user:user /home/user

# Activate the conda env here so that non-interactive commands
# (docker compose run <svc> python ...) get the right interpreter.
# .bashrc only covers interactive shells, and base has no torch.
source /opt/conda/etc/profile.d/conda.sh
conda activate diffusion_policy

# Switch to user
exec gosu user "$@"
