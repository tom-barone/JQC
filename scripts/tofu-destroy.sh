#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"

# Fail if trying to destroy the production environment
if [[ "$environment" == "production" ]]; then
	echo "Error: Destroying the production environment is not allowed."
	exit 1
fi

source scripts/tofu-env.sh "$environment"
source scripts/tofu-init.sh "$environment"

tofu -chdir=$TOFU_DIR destroy -auto-approve
