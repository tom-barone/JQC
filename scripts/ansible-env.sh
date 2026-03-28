#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
set -o allexport && eval "$(just secrets-export)" && set +o allexport

tofu_output_json=$(source scripts/tofu-output.sh "$environment")

export JQC_SERVER_IP_ADDRESS=$(echo "$tofu_output_json" | jq -r '.JQC_SERVER_IP_ADDRESS.value')
export JQC_HOSTNAME=$(echo "$tofu_output_json" | jq -r '.JQC_HOSTNAME.value')
export JQC_HOSTNAME_MONITORING=$(echo "$tofu_output_json" | jq -r '.JQC_HOSTNAME_MONITORING.value')

# Add the SSH key to our agent first
echo "$ANSIBLE_SSH_PRIVATE_KEY_B64" | base64 --decode | ssh-add -
# Removing the server from known_hosts to avoid SSH warnings about changed host keys
ssh-keygen -R "$JQC_SERVER_IP_ADDRESS"
