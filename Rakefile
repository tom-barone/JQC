# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task format: :environment do
  sh 'bundle exec rubocop --autocorrect-all --fail-level F'
  sh 'bundle exec rubocop --fix-layout --autocorrect-all --fail-level F'
  sh 'find app -name "*.html.erb" -exec bundle exec erb-formatter --write {} \;'
  sh 'npx prettier --write **/*.{js,html}'
end
