# frozen_string_literal: true

namespace :db do
  desc 'Copy the PROD database to the database specified in ENV[TARGET]'
  task copy_prod: :environment do
    username = Rails.application.credentials.db_username!
    password = Rails.application.credentials.db_password!
    target_database = ENV['TARGET'] || 'DEV'

    tables =
      `echo 'SELECT table_name FROM information_schema.tables
      where table_schema="PROD"' | rails db -p | tail -n +2 |
      tr '\r\n' ' '`
    system "mysqldump \
        --host 127.0.0.1 \
        --user #{username} \
        --password=#{password} \
        -P 3306 \
        --hex-blob --skip-triggers --set-gtid-purged=OFF \
        PROD #{tables} \
        | mysql \
        --host 127.0.0.1 \
        --user #{username} \
        --password=#{password} \
        -P 3306 \
        #{target_database}"
  end
end
