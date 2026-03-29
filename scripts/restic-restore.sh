#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
source scripts/ansible-env.sh "$environment"

echo "Stopping kamal app containers..."
kamal app stop --quiet

echo "Restoring backups on server..."
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" bash -s <<'REMOTE'
set -euo pipefail

echo "Recreating postgres container..."
cd /opt/postgres
docker compose down
rm -rf /opt/postgres/data/*
docker compose up -d
until docker exec postgres pg_isready -U postgres; do
  sleep 3
done

echo "Restoring postgres backup..."
source /opt/postgres-backup/env
restic dump latest pg_dumpall.sql | docker exec -i postgres psql -U postgres

echo "Restoring active storage backup..."
rm -rf /opt/rails/storage/*
source /opt/active-storage-backup/env
restic restore latest --target /
REMOTE

echo "Restart app with kamal..."
kamal app boot --quiet
