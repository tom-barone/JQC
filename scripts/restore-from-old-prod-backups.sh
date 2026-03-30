#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
source scripts/ansible-env.sh "$environment"

# Extract old S3 credentials from Rails encrypted credentials
echo "Reading old production credentials..."
eval "$(bundle exec rails runner '
  pg = Rails.application.credentials.postgres_backups
  as = Rails.application.credentials.active_storage
  puts "export OLD_PG_BUCKET=\"#{pg[:aws_s3_bucket]}\""
  puts "export OLD_PG_ACCESS_KEY=\"#{pg[:aws_access_key_id]}\""
  puts "export OLD_PG_SECRET_KEY=\"#{pg[:aws_secret_access_key]}\""
  puts "export OLD_PG_REGION=\"#{pg[:aws_region]}\""
  puts "export OLD_PG_ENCRYPTION_KEY=\"#{pg[:encryption_key]}\""
  puts "export OLD_AS_BUCKET=\"#{as[:aws_s3_bucket]}\""
  puts "export OLD_AS_ACCESS_KEY=\"#{as[:aws_access_key_id]}\""
  puts "export OLD_AS_SECRET_KEY=\"#{as[:aws_secret_access_key]}\""
  puts "export OLD_AS_REGION=\"#{as[:aws_region]}\""
')"

echo "Stopping kamal app containers..."
kamal app stop --quiet

echo "Recreating postgres container on server..."
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" bash -s <<'REMOTE'
set -euo pipefail
cd /opt/postgres
docker compose down
rm -rf /opt/postgres/data/*
docker compose up -d
until docker exec postgres pg_isready -U postgres; do
  sleep 3
done
REMOTE

echo "Fetching most recent postgres backup from old S3..."
most_recent_backup=$(AWS_ACCESS_KEY_ID="$OLD_PG_ACCESS_KEY" \
	AWS_SECRET_ACCESS_KEY="$OLD_PG_SECRET_KEY" \
	AWS_DEFAULT_REGION="$OLD_PG_REGION" \
	aws s3api list-objects-v2 --bucket "$OLD_PG_BUCKET" \
	--query 'sort_by(Contents, &LastModified)[-1].Key' \
	--output text)

echo "Downloading backup: $most_recent_backup"
AWS_ACCESS_KEY_ID="$OLD_PG_ACCESS_KEY" \
	AWS_SECRET_ACCESS_KEY="$OLD_PG_SECRET_KEY" \
	AWS_DEFAULT_REGION="$OLD_PG_REGION" \
	aws s3 cp "s3://$OLD_PG_BUCKET/$most_recent_backup" .

echo "Decrypting and extracting backup..."
echo "$OLD_PG_ENCRYPTION_KEY" | gpg --passphrase-fd 0 --batch --decrypt "$most_recent_backup" >latest_backup.tgz
tar -xf latest_backup.tgz
rm -f latest_backup.tgz "$most_recent_backup"

echo "Uploading and restoring postgres backup on server..."
scp -o StrictHostKeyChecking=no backup/export "root@$JQC_SERVER_IP_ADDRESS:/tmp/pg_backup"
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" bash -s <<'REMOTE'
set -euo pipefail
docker exec postgres createdb -U postgres jqc_production
cat /tmp/pg_backup | docker exec -i postgres pg_restore --dbname=jqc_production -U postgres --no-owner --no-privileges || true
rm -f /tmp/pg_backup
REMOTE
rm -rf backup

echo "Downloading Active Storage files from old S3..."
mkdir -p tmp/old_active_storage
AWS_ACCESS_KEY_ID="$OLD_AS_ACCESS_KEY" \
	AWS_SECRET_ACCESS_KEY="$OLD_AS_SECRET_KEY" \
	AWS_DEFAULT_REGION="$OLD_AS_REGION" \
	aws s3 sync "s3://jqc-active-storage-production" tmp/old_active_storage/

echo "Reorganizing files for local disk storage..."
mkdir -p tmp/active_storage_local
for file in tmp/old_active_storage/*; do
	[ -f "$file" ] || continue
	key=$(basename "$file")
	dir1=${key:0:2}
	dir2=${key:2:2}
	mkdir -p "tmp/active_storage_local/$dir1/$dir2"
	cp "$file" "tmp/active_storage_local/$dir1/$dir2/$key"
done

echo "Uploading Active Storage files to server..."
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" 'rm -rf /opt/rails/storage/*'
scp -r -o StrictHostKeyChecking=no tmp/active_storage_local/* "root@$JQC_SERVER_IP_ADDRESS:/opt/rails/storage/"
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" 'chown -R 1000:1000 /opt/rails/storage'
rm -rf tmp/old_active_storage tmp/active_storage_local

echo "Updating Active Storage service name in database..."
ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" bash -s <<'REMOTE'
set -euo pipefail
docker exec postgres psql -U postgres -d jqc_production -c "UPDATE active_storage_blobs SET service_name = 'local';"
REMOTE

echo "Starting kamal app..."
kamal app boot --quiet
kamal app exec --roles=web "bin/rails db:migrate" --quiet

echo "Migration from old production complete!"
