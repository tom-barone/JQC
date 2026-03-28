#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
set -o allexport && eval "$(just secrets-export)" && set +o allexport

export SERVER_IP_ADDRESS=$(source scripts/tofu-output.sh "$environment" SERVER_IP_ADDRESS)

# Add the SSH key to our agent first
echo "$ANSIBLE_SSH_PRIVATE_KEY_B64" | base64 --decode | ssh-add -
# Removing the server from known_hosts to avoid SSH warnings about changed host keys
ssh-keygen -R "$SERVER_IP_ADDRESS"
