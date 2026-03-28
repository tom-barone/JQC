#!/usr/bin/env bash
# Source this file, don't execute it

set -euo pipefail
environment="$1"
source scripts/tofu-env.sh "$environment"

tofu -chdir="$TOFU_DIR" init \
	-backend-config=bucket=$OPENTOFU_BACKEND_S3_BUCKET_NAME \
	-backend-config=key=$environment.tfstate \
	-backend-config=region=$OPENTOFU_BACKEND_S3_REGION \
	-reconfigure
