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
  sh 'bundle exec erb_lint --autocorrect --lint-all'
  sh 'npx prettier --write app/javascript/**/*.js'
end

task lint: :environment do
  sh 'bundle exec bin/rubocop' # Run with --autocorrect-all to fix offenses
  sh 'bundle exec bin/brakeman --no-pager'
  sh 'bundle exec erb_lint --lint-all'
  sh 'npx eslint app/javascript'
  sh 'bundle exec bin/importmap audit'
end

task dev: %i[environment install] do
  sh 'bundle exec bin/rails db:migrate'
  sh 'bundle exec bin/rails db:seed'
  sh 'PORT=3008 bundle exec bin/dev'
end

task dev_with_test_db: %i[environment] do
  sh 'bundle exec bin/rails db:test:prepare'
  sh 'RAILS_ENV=test bundle exec bin/rails db:fixtures:load'
  sh 'RAILS_ENV=test bundle exec rake dev'
end

# I can't call this 'test' otherwise it'll conflict with Rails' test task
task test_all: :environment do
  if ENV['COVERAGE'] == 'true'
    FileUtils.rm_rf('ci') if File.directory?('ci')
    puts 'Running tests with coverage reports' if ENV['COVERAGE'] == 'true'
  end

  sh 'npm run test'
  sh 'bundle exec bin/rails db:test:prepare'
  sh 'bundle exec bin/rails test:all'
  # sh 'bundle exec bin/rails test ./test/system/basic_health_test.rb'

  Rake::Task['check_for_recent_backup'].invoke
end

task precommit: %i[environment install format lint test_all]

### Deployment and backup tasks

task run_deployment_checks: %i[environment] do
  sh 'bundle exec ruby deployment_checks/run.rb'
end

task schedule_postgres_backups_to_s3: %i[environment] do
  remote = ENV.fetch('DOKKU_REMOTE')
  db_name = ENV.fetch('DOKKU_DB_NAME')

  config = Rails.application.credentials.postgres_backups
  aws_bucket = config[:aws_s3_bucket]
  aws_access_key_id = config[:aws_access_key_id]
  aws_secret_access_key = config[:aws_secret_access_key]
  aws_region = config[:aws_region]
  schedule = config[:schedule].gsub('*', '\\*')
  encryption_key = config[:encryption_key]

  dokku = "dokku --remote #{remote}"
  sh "#{dokku} postgres:backup-unset-encryption #{db_name}"
  sh "#{dokku} postgres:backup-set-encryption #{db_name} #{encryption_key}"
  sh "#{dokku} postgres:backup-deauth #{db_name}"
  sh "#{dokku} postgres:backup-auth #{db_name} #{aws_access_key_id} #{aws_secret_access_key} #{aws_region}",
     verbose: false
  sh "#{dokku} postgres:backup-schedule #{db_name} \\\"#{schedule}\\\" #{aws_bucket}"
end

task manual_backup_to_s3: %i[environment] do
  remote = ENV.fetch('DOKKU_REMOTE')
  db_name = ENV.fetch('DOKKU_DB_NAME')

  config = Rails.application.credentials.postgres_backups
  aws_bucket = config[:aws_s3_bucket]
  dokku = "dokku --remote #{remote}"
  sh "#{dokku} postgres:backup #{db_name} #{aws_bucket}"
end

task restore_development_db_from_most_recent_backup: %i[environment] do
  local_db_name = ENV.fetch('LOCAL_DB_NAME')

  config = Rails.application.credentials.postgres_backups
  aws_bucket = config[:aws_s3_bucket]
  aws_access_key_id = config[:aws_access_key_id]
  aws_secret_access_key = config[:aws_secret_access_key]
  encryption_key = config[:encryption_key]

  # Find the most recent backup saved to S3
  credentials = "AWS_ACCESS_KEY_ID=#{aws_access_key_id} AWS_SECRET_ACCESS_KEY=#{aws_secret_access_key}"
  most_recent_backup = `#{credentials} aws s3api list-objects-v2 --bucket #{aws_bucket} \
    --query 'sort_by(Contents, &LastModified)[-1].Key' \
    --output=text`.strip

  # Download it to the local machine
  sh "#{credentials} aws s3 cp s3://#{aws_bucket}/#{most_recent_backup} ."

  # Decrypt and unzip the backup
  sh "echo '#{encryption_key}' | gpg --passphrase-fd 0 --batch --decrypt #{most_recent_backup} > latest_backup.tgz"
  sh 'tar -xf latest_backup.tgz && rm latest_backup.tgz'

  # Restore to local development database
  sh "pg_restore --clean --dbname=#{local_db_name} --exit-on-error backup/export"
  sh "rm -rf #{most_recent_backup} latest_backup.tgz backup"
end

task check_for_recent_backup: %i[environment] do
  puts 'Checking for recent backup in S3'
  # Check that we have a backup within the last 24 hours
  config = Rails.application.credentials.postgres_backups
  aws_bucket = config[:aws_s3_bucket]
  aws_access_key_id = config[:aws_access_key_id]
  aws_secret_access_key = config[:aws_secret_access_key]

  sh "AWS_ACCESS_KEY_ID=#{aws_access_key_id} " \
     "AWS_SECRET_ACCESS_KEY=#{aws_secret_access_key} " \
     'aws s3api list-objects-v2 ' \
     "--bucket #{aws_bucket} " \
     "--query 'Contents[?LastModified>=`#{24.hours.ago.iso8601}`].Key' " \
     '--output json > s3_list.json', verbose: false

  s3_list = JSON.parse(File.read('s3_list.json'))
  File.delete('s3_list.json')
  if s3_list.blank?
    puts 'Error: No backup found within the last 24 hours'
    exit 1
  end
  if s3_list.length > 1
    puts "Error: #{s3_list.length} backups found within the last 24 hours"
    exit 1
  end
end

Rails.application.load_tasks
