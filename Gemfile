# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.10'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.2'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft', '~> 1.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5.9'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.6.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails', '~> 2.1.0'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails', '~> 2.0.16'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails', '~> 1.3.4'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder', '~> 2.13.0'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable', '~> 3.0.11'
gem 'solid_cache', '~> 1.0.7'
gem 'solid_queue', '~> 1.2.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18.6', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', '~> 0.1.14', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# User management [https://github.com/heartcombo/devise]
gem 'devise', '~> 4.9.4'

# Quickly cloning a parent record with all of it's children [https://github.com/amoeba-rb/amoeba]
gem 'amoeba', '~> 3.3.0'

# Pagination [https://github.com/ddnexus/pagy]
gem 'pagy', '~> 9.3.5'

# For reporting exceptions [https://github.com/smartinez87/exception_notification]
gem 'exception_notification', '~> 5.0.0'

# For monitoring and metrics [https://github.com/Shopify/statsd-instrument]
gem 'statsd-instrument', '~> 3.9.9'

# Won't be included by default in the future
gem 'csv', '~> 3.3.5'

# Cocoon makes it easier to handle nested forms [https://github.com/nathanvda/cocoon]
gem 'cocoon', '~> 1.2.15'

# Generating PDFs [https://github.com/excid3/ferrum_pdf]
gem 'ferrum_pdf', '~> 0.3.0'

# Active storage on S3
# [https://guides.rubyonrails.org/active_storage_overview.html#s3-service-amazon-s3-and-s3-compatible-apis]
gem 'aws-sdk-s3', '~> 1.208.0', require: false

# OpenSSL updates and patches, since the stdlib version sometimes lags behind
# [https://rubygems.org/gems/openssl]
gem 'openssl', '~> 4.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', '~> 1.11.0', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', '~> 7.1.1', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  # gem "rubocop-rails-omakase", require: false

  # For linting and formatting [https://github.com/rubocop/rubocop]
  gem 'rubocop', '~> 1.81.7'

  gem 'rubocop-capybara', '~> 2.22.1', require: false

  # Extra cops for factory_bot best practices [https://github.com/rubocop/rubocop-factory_bot]
  gem 'rubocop-factory_bot', '~> 2.28.0', require: false

  # Extra cops for minitest best practices [https://github.com/rubocop/rubocop-minitest]
  gem 'rubocop-minitest', '~> 0.38.2', require: false

  # [https://github.com/rubocop/rubocop-performance]
  gem 'rubocop-performance', '~> 1.26.1', require: false

  gem 'rubocop-rails', '~> 2.34.0', require: false

  # HTML safety [https://github.com/Shopify/better-html]
  gem 'better_html', '~> 2.2.0'

  # ERB linting [https://github.com/Shopify/erb_lint]
  gem 'erb_lint', '~> 0.9.0', require: false

  # For formatting ERB code [https://github.com/nebulab/erb-formatter]
  gem 'erb-formatter', '~> 0.7.3'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console', '~> 4.2.1'

  # Handy for generating scaffold commands [https://github.com/frenesim/schema_to_scaffold]
  gem 'schema_to_scaffold', '~> 0.8.0'

  # For viewing emails in development [https://github.com/ryanb/letter_opener]
  gem 'letter_opener', '~> 1.10.0'

  # For finding memory leaks
  gem 'derailed_benchmarks', '~> 2.2.1'
  gem 'stackprof', '~> 0.2.27'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara', '~> 3.40.0'
  gem 'selenium-webdriver', '~> 4.38.0'

  # Use SimpleCov for code coverage [https://github.com/simplecov-ruby/simplecov]
  gem 'simplecov', '~> 0.22.0', require: false

  gem 'minitest-reporters', '~> 1.7.1'

  # For generating test data [https://github.com/thoughtbot/factory_bot_rails]
  gem 'factory_bot_rails', '~> 6.5.1'

  # For generating fake data in tests [https://github.com/faker-ruby/faker]
  gem 'faker', '~> 3.5.2'
end
