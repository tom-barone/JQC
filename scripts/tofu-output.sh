#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
source scripts/tofu-env.sh "$environment" > /dev/null
source scripts/tofu-init.sh "$environment" > /dev/null

tofu -chdir=$TOFU_DIR output -json
