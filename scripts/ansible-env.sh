#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
set -o allexport && eval "$(just secrets-export)" && set +o allexport

tofu_output_json=$(source scripts/tofu-output.sh "$environment")

export ENVIRONMENT="$environment"
export JQC_SERVER_IP_ADDRESS=$(echo "$tofu_output_json" | jq -r '.JQC_SERVER_IP_ADDRESS.value')
export JQC_HOSTNAME=$(echo "$tofu_output_json" | jq -r '.JQC_HOSTNAME.value')
export JQC_HOSTNAME_MONITORING=$(echo "$tofu_output_json" | jq -r '.JQC_HOSTNAME_MONITORING.value')
export RESTIC_POSTGRES_S3_BUCKET=$(echo "$tofu_output_json" | jq -r '.RESTIC_POSTGRES_S3_BUCKET.value')
export RESTIC_POSTGRES_S3_ENDPOINT=$(echo "$tofu_output_json" | jq -r '.RESTIC_POSTGRES_S3_ENDPOINT.value')
export RESTIC_POSTGRES_S3_ACCESS_KEY=$(echo "$tofu_output_json" | jq -r '.RESTIC_POSTGRES_S3_ACCESS_KEY.value')
export RESTIC_POSTGRES_S3_SECRET_KEY=$(echo "$tofu_output_json" | jq -r '.RESTIC_POSTGRES_S3_SECRET_KEY.value')
export RESTIC_ACTIVE_STORAGE_S3_BUCKET=$(echo "$tofu_output_json" | jq -r '.RESTIC_ACTIVE_STORAGE_S3_BUCKET.value')
export RESTIC_ACTIVE_STORAGE_S3_ENDPOINT=$(echo "$tofu_output_json" | jq -r '.RESTIC_ACTIVE_STORAGE_S3_ENDPOINT.value')
export RESTIC_ACTIVE_STORAGE_S3_ACCESS_KEY=$(echo "$tofu_output_json" | jq -r '.RESTIC_ACTIVE_STORAGE_S3_ACCESS_KEY.value')
export RESTIC_ACTIVE_STORAGE_S3_SECRET_KEY=$(echo "$tofu_output_json" | jq -r '.RESTIC_ACTIVE_STORAGE_S3_SECRET_KEY.value')
export SMTP_RELAY_HOST=$(echo "$tofu_output_json" | jq -r '.SMTP_RELAY_HOST.value')
export SMTP_RELAY_PORT=$(echo "$tofu_output_json" | jq -r '.SMTP_RELAY_PORT.value')
export SMTP_RELAY_USERNAME=$(echo "$tofu_output_json" | jq -r '.SMTP_RELAY_USERNAME.value')
export SMTP_RELAY_PASSWORD=$(echo "$tofu_output_json" | jq -r '.SMTP_RELAY_PASSWORD.value')

# Add the SSH key to our agent first
echo "$ANSIBLE_SSH_PRIVATE_KEY_B64" | base64 --decode | ssh-add - 2>/dev/null
# Removing the server from known_hosts to avoid SSH warnings about changed host keys
ssh-keygen -R "$JQC_SERVER_IP_ADDRESS"
