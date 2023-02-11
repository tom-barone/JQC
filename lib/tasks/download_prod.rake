# frozen_string_literal: true

namespace :db do
  desc 'Download the PROD database to your local machine'
  # Needs to be run with "RAILS_ENV=production rails db:download_prod"
  task :download_prod => :environment do
    username = Rails.application.credentials.db_username!
    password = Rails.application.credentials.db_password!

    tables = `echo 'SELECT table_name FROM information_schema.tables
    where table_schema="PROD"' | rails db | tail -n +2 | tr '\r\n' ' '`

    system "mysqldump \
        --host 127.0.0.1 \
        --user #{username} \
        --password=#{password} \
        -P 3306 \
        --hex-blob --skip-triggers --set-gtid-purged=OFF \
        PROD #{tables} > dump-#{Time.current.strftime('%Y_%m_%d')}.sql"
  end
end
