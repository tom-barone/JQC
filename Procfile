release: bundle exec bin/rails db:migrate && bundle exec bin/rails db:seed
web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start
