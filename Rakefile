# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

task lint: :environment do
  sh 'bundle exec rubocop' # Run with --autocorrect-all to fix offenses
  sh 'bundle exec brakeman --no-pager'
  # sh 'npx tsc'
end

task format: :environment do
  sh 'bundle exec rubocop --autocorrect-all --fail-level F'
  sh 'bundle exec rubocop --fix-layout --autocorrect-all --fail-level F'
  sh 'find app -name "*.html.erb" -exec bundle exec erb-formatter --write {} \;'
  # sh 'npx prettier --write app/javascript/**/*.{js,ts}'
end

Rails.application.load_tasks
