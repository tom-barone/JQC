#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
source scripts/ansible-env.sh "$environment"

echo "Running restic backups on server..."
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" bash -s <<'REMOTE'
set -euo pipefail

echo "Backing up postgres..."
/opt/postgres-backup/backup.sh

echo "Backing up active storage..."
/opt/active-storage-backup/backup.sh
REMOTE

echo "Backups complete."
