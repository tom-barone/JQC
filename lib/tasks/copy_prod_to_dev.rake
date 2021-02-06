require 'highline'

namespace :db do
  desc 'Copy the PROD database to DEV'
  task :copy_prod_to_dev do
    # TODO: Get the host and port from config/database.yml
    cli = HighLine.new
    user = cli.ask('user: ')
    password = cli.ask('password: ') { |q| q.echo = 'x' }

    tables =
      `echo 'SELECT table_name FROM information_schema.tables where table_schema="PROD"' | rails db | tail -n +2 | tr '\r\n' ' '`
    system "mysqldump \
        --host 127.0.0.1 \
        --user #{user} \
        --password=#{password} \
        -P 3306 \
        --hex-blob --skip-triggers --set-gtid-purged=OFF \
        PROD #{tables} \
        | mysql \
        --host 127.0.0.1 \
        --user #{user} \
        --password=#{password} \
        -P 3306 \
        DEV"
  end
end