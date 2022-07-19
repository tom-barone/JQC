# frozen_string_literal: true
namespace :db do
  desc 'Copy the PROD database to DEV'
  task :copy_prod_to_dev do
    username = Rails.application.credentials.db_username!
    password = Rails.application.credentials.db_password!

    tables =
      `echo 'SELECT table_name FROM information_schema.tables where table_schema="PROD"' | rails db | tail -n +2 | tr '\r\n' ' '`
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
        DEV"
  end
end
