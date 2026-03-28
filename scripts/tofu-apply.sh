#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
source scripts/tofu-env.sh "$environment"
source scripts/tofu-init.sh "$environment"

tofu -chdir=$TOFU_DIR plan
tofu -chdir=$TOFU_DIR apply -auto-approve
