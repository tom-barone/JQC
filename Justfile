default: help

@help:
    just --list

# Install dependencies
@install:
    bundle install
    npm install

# Start the Rails development server
@dev:
    bundle exec bin/rails db:migrate
    bundle exec bin/rails db:seed
    PORT=3008 SOLID_QUEUE_IN_PUMA=true bundle exec bin/dev

# Run linters
@lint:
    docker run --rm -i hadolint/hadolint < Dockerfile
    bundle exec bin/rubocop --autocorrect-all --fail-level I
    bundle exec bin/brakeman --no-pager --quiet --no-summary
    bundle exec erb_lint --lint-all
    npx eslint app/javascript
    bundle exec bin/importmap audit

@build:
    docker build .

# Run tests
@test:
    npm run test
    RAILS_ENV=test bundle exec bin/rails db:prepare
    COVERAGE=true bundle exec bin/rails test:all

# Run formatters
@format:
    bundle exec bin/rubocop --fix-layout
    @# These two formatters sort of conflict with each other, but they both do useful things
    @# erb_lint is ultimately better for now so run it last.
    find app -name "*.html.erb" -print0 | xargs -0 --max-procs=8 -I {} bundle exec erb-formatter --write {}
    bundle exec erb_lint --autocorrect --lint-all
    npx prettier --write app/javascript/**/*.js --log-level warn

# Clean up generated files
@clean:
    rm -rf ci

# Run all pre-commit checks
@precommit: clean install format lint build test

alias l := lint
alias t := test
alias f := format
alias d := dev
alias c := clean
alias pre := precommit
