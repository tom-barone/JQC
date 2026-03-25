[private]
default: help

[doc('Show this help message')]
help:
    @just --list

[doc('Install dependencies')]
[group('Development')]
install:
    mise install
    bundle install
    npm install

[doc('Start the development server')]
[group('Development')]
dev:
    bundle exec bin/rails db:migrate
    bundle exec bin/rails db:seed
    PORT=3008 SOLID_QUEUE_IN_PUMA=true bundle exec bin/dev

[doc('Run linters')]
[group('Development')]
lint:
    docker run --rm -i hadolint/hadolint < Dockerfile
    bundle exec bin/rubocop --autocorrect-all --fail-level I
    bundle exec bin/brakeman --no-pager --quiet --no-summary
    bundle exec erb_lint --lint-all
    npx eslint app/javascript
    bundle exec bin/importmap audit

[doc('Build the Docker image')]
[group('Development')]
build:
    docker build .

[doc('Run tests')]
[group('Development')]
test:
    npm run test
    RAILS_ENV=test bundle exec bin/rails db:prepare
    COVERAGE=true bundle exec bin/rails test:all

[doc('Run formatters')]
[group('Development')]
format:
    bundle exec bin/rubocop --fix-layout
    @# These two formatters sort of conflict with each other, but they both do useful things
    @# erb_lint is ultimately better for now so run it last.
    find app -name "*.html.erb" -print0 | xargs -0 --max-procs=8 -I {} bundle exec erb-formatter --write {}
    bundle exec erb_lint --autocorrect --lint-all
    npx prettier --write app/javascript/**/*.js --log-level warn

[doc('Clean up generated files')]
[group('Development')]
clean:
    rm -rf ci

[doc('Run all pre-commit checks')]
[group('Development')]
precommit: clean install format lint build test

# == Deployment ==

[doc('Deploy to production')]
[group('Deploy')]
deploy-production:
    #!/usr/bin/env bash
    set -euo pipefail
    set -o allexport && eval "$(just secrets-export)" && set +o allexport 
    # Set OpenTofu variables
    export AWS_ACCESS_KEY_ID=$OPENTOFU_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$OPENTOFU_AWS_SECRET_ACCESS_KEY
    export TF_VAR_opentofu_state_encryption_password="$OPENTOFU_STATE_ENCRYPTION_PASSWORD"
    export TF_VAR_backup_primary_s3_bucket_name="$BACKUP_PRIMARY_S3_BUCKET_NAME"
    export TF_VAR_linode_region="$LINODE_REGION"
    export TF_VAR_ansible_ssh_public_key="$ANSIBLE_SSH_PUBLIC_KEY"

    tofu -chdir=infrastructure/production init \
      -backend-config=bucket=$OPENTOFU_BACKEND_S3_BUCKET_NAME \
      -backend-config=key=production.tfstate \
      -backend-config=region=$OPENTOFU_BACKEND_S3_REGION \
      -reconfigure
    tofu -chdir=infrastructure/production plan
    tofu -chdir=infrastructure/production apply -auto-approve

[doc('Deploy an ephemeral staging environment')]
[group('Deploy')]
deploy-staging NAME:
    #!/usr/bin/env bash
    set -euo pipefail
    set -o allexport && eval "$(just secrets-export)" && set +o allexport 
    # Set OpenTofu variables
    export AWS_ACCESS_KEY_ID=$OPENTOFU_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$OPENTOFU_AWS_SECRET_ACCESS_KEY
    export TF_VAR_staging_name="{{ NAME }}"
    export TF_VAR_opentofu_state_encryption_password="$OPENTOFU_STATE_ENCRYPTION_PASSWORD"
    export TF_VAR_backup_primary_s3_bucket_name="$BACKUP_PRIMARY_S3_BUCKET_NAME"
    export TF_VAR_linode_region="$LINODE_REGION"
    export TF_VAR_ansible_ssh_public_key="$ANSIBLE_SSH_PUBLIC_KEY"

    tofu -chdir=infrastructure/staging init \
      -backend-config=bucket=$OPENTOFU_BACKEND_S3_BUCKET_NAME \
      -backend-config=key={{ NAME }}.tfstate \
      -backend-config=region=$OPENTOFU_BACKEND_S3_REGION \
      -reconfigure
    tofu -chdir=infrastructure/staging plan
    tofu -chdir=infrastructure/staging apply -auto-approve

[doc('Destroy an ephemeral staging environment')]
[group('Deploy')]
destroy-staging NAME:
    #!/usr/bin/env bash
    set -euo pipefail
    set -o allexport && eval "$(just secrets-export)" && set +o allexport 
    # Set OpenTofu variables
    export AWS_ACCESS_KEY_ID=$OPENTOFU_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$OPENTOFU_AWS_SECRET_ACCESS_KEY
    export TF_VAR_staging_name="{{ NAME }}"
    export TF_VAR_opentofu_state_encryption_password="$OPENTOFU_STATE_ENCRYPTION_PASSWORD"
    export TF_VAR_backup_primary_s3_bucket_name="$BACKUP_PRIMARY_S3_BUCKET_NAME"
    export TF_VAR_linode_region="$LINODE_REGION"
    export TF_VAR_ansible_ssh_public_key="$ANSIBLE_SSH_PUBLIC_KEY"

    tofu -chdir=infrastructure/staging destroy -auto-approve \
      -var="staging_name={{ NAME }}"

# === Environment ===

[doc("Edit secrets with sops")]
[group('Environment')]
secrets-edit:
    sops secrets.sops.env

[doc('Inject secrets into the environment and run a command')]
[group('Environment')]
secrets-export:
    @sops --decrypt secrets.sops.env

alias l := lint
alias t := test
alias f := format
alias d := dev
alias c := clean
alias pre := precommit
