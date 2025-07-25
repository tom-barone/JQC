# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.7'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.2'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# User management [https://github.com/heartcombo/devise]
gem 'devise'

# Quickly cloning a parent record with all of it's children [https://github.com/amoeba-rb/amoeba]
gem 'amoeba'

# Pagination [https://github.com/ddnexus/pagy]
gem 'pagy'

# For reporting exceptions [https://github.com/smartinez87/exception_notification]
gem 'exception_notification'

# For monitoring and metrics [https://github.com/Shopify/statsd-instrument]
gem 'statsd-instrument'

# Won't be included by default in the future
gem 'csv'

# Cocoon makes it easier to handle nested forms [https://github.com/nathanvda/cocoon]
gem 'cocoon'

# Generating PDFs [https://github.com/excid3/ferrum_pdf]
gem 'ferrum_pdf', '= 0.3.0'

# Active storage on S3
# [https://guides.rubyonrails.org/active_storage_overview.html#s3-service-amazon-s3-and-s3-compatible-apis]
gem 'aws-sdk-s3', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  # gem "rubocop-rails-omakase", require: false

  # For linting and formatting [https://github.com/rubocop/rubocop]
  gem 'rubocop'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-rails', require: false
  # [https://github.com/rubocop/rubocop-performance]
  gem 'rubocop-performance', require: false

  # HTML safety [https://github.com/Shopify/better-html]
  gem 'better_html'

  # ERB linting [https://github.com/Shopify/erb_lint]
  gem 'erb_lint', require: false

  # For formatting ERB code [https://github.com/nebulab/erb-formatter]
  gem 'erb-formatter'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Handy for generating scaffold commands [https://github.com/frenesim/schema_to_scaffold]
  gem 'schema_to_scaffold'

  # For viewing emails in development [https://github.com/ryanb/letter_opener]
  gem 'letter_opener'

  # For finding memory leaks
  gem 'derailed_benchmarks'
  gem 'stackprof'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'

  # Use SimpleCov for code coverage [https://github.com/simplecov-ruby/simplecov]
  gem 'simplecov', require: false

  gem 'minitest-reporters'
end
