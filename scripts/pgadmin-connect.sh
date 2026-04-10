#!/usr/bin/env bash
set -euo pipefail

environment="$1"
source scripts/ansible-env.sh "$environment"

PGADMIN_CONTAINER="pgadmin4-temp"

cleanup() {
	echo "Shutting down..."
	docker rm -f "$PGADMIN_CONTAINER" 2>/dev/null || true
	kill "$SSH_PID" 2>/dev/null || true
	rm -f "$SERVERS_JSON"
	echo "Done."
}
trap cleanup EXIT

# SSH port forward
ssh -L 5433:127.0.0.1:5432 -N -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" &
SSH_PID=$!
sleep 2

# servers.json with password file
SERVERS_JSON=$(mktemp)
cat >"$SERVERS_JSON" <<EOF
{
  "Servers": {
    "1": {
      "Name": "$environment",
      "Group": "Servers",
      "Host": "host.docker.internal",
      "Port": 5433,
      "MaintenanceDB": "postgres",
      "Username": "postgres",
      "SSLMode": "prefer",
      "PassFile": "/tmp/pgpassfile"
    }
  }
}
EOF

# pgAdmin container
docker run --rm --name "$PGADMIN_CONTAINER" \
	-p 5050:80 \
	-e PGADMIN_DEFAULT_EMAIL=admin@admin.com \
	-e PGADMIN_DEFAULT_PASSWORD=admin \
	-e PGADMIN_CONFIG_SERVER_MODE=False \
	-v "$SERVERS_JSON":/pgadmin4/servers.json \
	dpage/pgadmin4 &
DOCKER_PID=$!

# Wait for pgAdmin to start, then inject the pgpassfile
sleep 5
docker exec "$PGADMIN_CONTAINER" sh -c "echo 'host.docker.internal:5433:*:postgres:${POSTGRES_PASSWORD}' > /tmp/pgpassfile && chmod 600 /tmp/pgpassfile"

echo ""
echo "pgAdmin4 running at http://localhost:5050"
echo "Press Ctrl-C to stop."
wait "$DOCKER_PID"
