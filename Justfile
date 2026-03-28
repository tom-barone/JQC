[private]
default: help

[doc('Show this help message')]
help:
    @just --list

export TOFU_DIR := "infrastructure/tofu"

# === Development ===

[doc('Install dependencies')]
[group('Development')]
install:
    mise install
    bundle install
    npm install
    tflint --chdir={{ TOFU_DIR }} --init --config=.tflint.hcl
    just tofu-init test

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
    cd {{ TOFU_DIR }} && tofu validate
    tflint --chdir={{ TOFU_DIR }} --config=.tflint.hcl

[doc('Build the Docker image')]
[group('Development')]
build:
    docker build . --tag jqc:latest

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
    kamal setup
    kamal app exec --roles=web "bin/rails db:prepare"
    kamal deploy
    kamal app logs -n 1000

# === OpenTofu ===

[doc('Initialize OpenTofu in the specified environment')]
[group('Deploy:Tofu')]
tofu-init ENVIRONMENT:
    source scripts/tofu-init.sh {{ ENVIRONMENT }}

[doc('Apply OpenTofu changes in the specified environment')]
[group('Deploy:Tofu')]
tofu-apply ENVIRONMENT:
    source scripts/tofu-apply.sh {{ ENVIRONMENT }}

[doc('Get a Tofu output variable')]
[group('Deploy:Tofu')]
tofu-output ENVIRONMENT VARIABLE:
    source scripts/tofu-output.sh {{ ENVIRONMENT }} {{ VARIABLE }}

[doc('Destroy OpenTofu infrastructure in the specified environment')]
[group('Deploy:Tofu')]
tofu-destroy ENVIRONMENT:
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

# === Aliases ===

alias l := lint
alias t := test
alias f := format
alias d := dev
alias c := clean
alias pre := precommit
