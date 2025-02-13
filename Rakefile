# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

task install: %i[environment] do
  sh 'bundle install'
  sh 'npm install'
end

task format: :environment do
  sh 'bundle exec bin/rubocop --autocorrect-all --fail-level F'
  sh 'bundle exec bin/rubocop --fix-layout --autocorrect-all --fail-level F'
  sh 'find app -name "*.html.erb" -exec bundle exec erb-formatter --write {} \;'
  sh 'npx prettier --write app/javascript/**/*.js'
end

task lint: :environment do
  sh 'bundle exec bin/rubocop' # Run with --autocorrect-all to fix offenses
  sh 'bundle exec bin/brakeman --no-pager'
  sh 'npx eslint app/javascript'
  sh 'bundle exec bin/importmap audit'
end

task dev: %i[environment install] do
  sh 'bundle exec bin/rails db:migrate'
  sh 'bundle exec bin/rails db:seed'
  sh 'PORT=3008 bundle exec bin/dev'
end

task test: :environment do
  sh 'bundle exec bin/rails db:test:prepare test:all'
end

task precommit: %i[environment install format lint test]

Rails.application.load_tasks
