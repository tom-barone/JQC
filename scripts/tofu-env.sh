#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
set -o allexport && eval "$(just secrets-export)" && set +o allexport

# Set OpenTofu variables
export AWS_ACCESS_KEY_ID=$OPENTOFU_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$OPENTOFU_AWS_SECRET_ACCESS_KEY
export TF_VAR_OPENTOFU_STATE_ENCRYPTION_PASSWORD="$OPENTOFU_STATE_ENCRYPTION_PASSWORD"
export TF_VAR_BACKUP_PRIMARY_S3_BUCKET_NAME="$BACKUP_PRIMARY_S3_BUCKET_NAME"
export TF_VAR_LINODE_REGION="$LINODE_REGION"
export TF_VAR_ANSIBLE_SSH_PUBLIC_KEY="$ANSIBLE_SSH_PUBLIC_KEY"
export TF_VAR_DOMAIN="$DOMAIN"
export TF_VAR_ENVIRONMENT="$environment"
