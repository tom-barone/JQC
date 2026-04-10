[private]
default: help

[doc('Show this help message')]
help:
    @just --list

export TOFU_DIR := "infrastructure/tofu"
export POSTGRES_USERNAME := "postgres"
export POSTGRES_DB := "jqc_production"
export POSTGRES_HOST := "postgres"
export POSTGRES_PORT := "5432"
export DOCKER_NETWORK := "jqc_network"
export RAILS_ACTIVE_STORAGE_DIR := "/opt/rails/storage"

# === Development ===

[doc('Install dependencies')]
[group('Development')]
install:
    mise install
    bundle install
    npm install
    tflint --chdir={{ TOFU_DIR }} --init --config=.tflint.hcl
    just tofu-init test
    cd infrastructure/ansible && uv sync
    cd infrastructure/ansible && uv run ansible-galaxy install -r requirements.yml

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
    yamllint --strict .github
    actionlint -color
    bundle exec bin/rubocop --autocorrect-all --fail-level I
    bundle exec bin/brakeman --no-pager --quiet --no-summary
    bundle exec erb_lint --lint-all
    npx eslint app/javascript
    bundle exec bin/importmap audit
    cd {{ TOFU_DIR }} && tofu validate
    tflint --chdir={{ TOFU_DIR }} --config=.tflint.hcl

[doc('Build the Docker image')]
[group('Development')]
build:
    docker buildx build . --tag jqc:latest --load {{ env("DOCKER_BUILD_ARGS", "") }}

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
    tofu fmt -recursive {{ TOFU_DIR }}

[doc('Clean up generated files')]
[group('Development')]
clean:
    rm -rf ci

[doc('Run all pre-commit checks')]
[group('Development')]
precommit: clean install format lint build

# === Deployment ===

[doc('Deploy to the specified environment')]
[group('Deploy')]
deploy ENVIRONMENT:
    just tofu-init {{ ENVIRONMENT }}
    just tofu-apply {{ ENVIRONMENT }}
    just ansible-deploy {{ ENVIRONMENT }}
    just kamal-deploy {{ ENVIRONMENT }}

[doc('SSH to the server in the specified environment')]
[group('Deploy')]
ssh ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/ansible-env.sh {{ ENVIRONMENT }}
    ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS"

[doc('Open a shell within the application container in the specified environment')]
[group('Deploy')]
enter ENVIRONMENT:
    just kamal {{ ENVIRONMENT }} app exec -i --reuse bash

[doc('Open a rails console in the specified environment')]
[group('Deploy')]
rails-console ENVIRONMENT:
    just kamal {{ ENVIRONMENT }} app exec -i --reuse "bin/rails console"

[doc('View the application in the specified environment')]
[group('Deploy')]
browse ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/ansible-env.sh {{ ENVIRONMENT }}
    python3 -m webbrowser "https://$JQC_HOSTNAME"
    python3 -m webbrowser "https://$JQC_HOSTNAME_MONITORING/dashboards"

[doc('Destroy infrastructure in the specified environment')]
[group('Deploy')]
destroy ENVIRONMENT: (tofu-destroy ENVIRONMENT)

# === Ansible ===

[doc('Run an Ansible playbook')]
[group('Deploy:Ansible')]
ansible-deploy ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/ansible-env.sh {{ ENVIRONMENT }}
    (cd infrastructure/ansible && uv run ansible-playbook -i inventory.yml deploy.yml)

# === Kamal ===

[doc('Deploy with Kamal')]
[group('Deploy:Kamal')]
kamal-deploy ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/ansible-env.sh {{ ENVIRONMENT }}
    bundle exec kamal setup --quiet
    bundle exec kamal app exec --roles=web "bin/rails db:prepare" --quiet
    bundle exec kamal deploy --quiet
    # Make sure the reverse-proxy can reach our docker network with all the services like grafana etc.
    # This is annoying but eventually Kamal should have a nice way of reverse-proxying to other stuff
    # without resorting to this.
    ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" \
      "docker network connect $DOCKER_NETWORK kamal-proxy 2>/dev/null || true"
    ssh -o StrictHostKeyChecking=no "root@$JQC_SERVER_IP_ADDRESS" \
      "docker exec kamal-proxy kamal-proxy deploy grafana --host $JQC_HOSTNAME_MONITORING --target grafana:3000 --tls --health-check-path /api/health"

[doc('Run a Kamal command')]
[group('Deploy:Kamal')]
kamal ENVIRONMENT *CMD:
    #!/usr/bin/env bash
    source scripts/ansible-env.sh {{ ENVIRONMENT }}
    bundle exec kamal {{ CMD }}

# === Restic ===

[doc('Manually run restic backups')]
[group('Deploy:Restic')]
restic-backup ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/restic-backup.sh {{ ENVIRONMENT }}

[doc('Restore a deployment from its restic backups')]
[group('Deploy:Restic')]
restic-restore ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/restic-restore.sh {{ ENVIRONMENT }}

# === OpenTofu ===

[doc('Initialize OpenTofu in the specified environment')]
[group('Deploy:Tofu')]
tofu-init ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/tofu-init.sh {{ ENVIRONMENT }}

[doc('Apply OpenTofu changes in the specified environment')]
[group('Deploy:Tofu')]
tofu-apply ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/tofu-apply.sh {{ ENVIRONMENT }}

[doc('Output OpenTofu values in the specified environment')]
[group('Deploy:Tofu')]
tofu-output ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/tofu-output.sh {{ ENVIRONMENT }}

[doc('Destroy OpenTofu infrastructure in the specified environment')]
[group('Deploy:Tofu')]
tofu-destroy ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/tofu-destroy.sh {{ ENVIRONMENT }}

# === Environment ===

[doc("Edit secrets with sops")]
[group('Environment')]
secrets-edit:
    sops secrets.sops.env

[doc('Inject secrets into the environment and run a command')]
[group('Environment')]
secrets-export:
    @sops --decrypt secrets.sops.env

[doc('Mask sensitive values in GitHub Actions logs')]
[group('Environment')]
secrets-mask:
    @sops --decrypt secrets.sops.env | grep -v '^#' | cut -d'=' -f2- | while read -r val; do \
        echo "::add-mask::$val"; \
    done

# === Temp ===

[doc('Restore from the old deployment setup')]
[group('Temp')]
restore-from-old-prod-backups ENVIRONMENT:
    #!/usr/bin/env bash
    source scripts/restore-from-old-prod-backups.sh {{ ENVIRONMENT }}

# === Aliases ===

alias l := lint
alias t := test
alias f := format
alias d := dev
alias c := clean
alias pre := precommit
