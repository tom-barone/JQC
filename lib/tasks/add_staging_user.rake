# frozen_string_literal: true

namespace :db do
  desc 'Add a staging user login to the STAGING environment'
  task add_staging_user: :environment do
    if ENV['RAILS_ENV'] != 'staging'
      abort("Cannot add staging user, RAILS_ENV must be 'staging' but found RAILS_ENV=#{ENV['RAILS_ENV']}")
    end
    puts 'Adding staging user...'
    User.create(
      username: Rails.application.credentials.staging_username!,
      email: 'staging@testemail.com',
      password: Rails.application.credentials.staging_password!,
      password_confirmation: Rails.application.credentials.staging_password!
    )
  end
end
