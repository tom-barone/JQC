# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
require_relative '../config/environment'
require 'minitest/autorun'
require 'minitest/reporters'

# We don't want to report any test results and possibly expose sensitive data
class MinimalReporter < Minitest::Reporters::DefaultReporter
  def on_report
    # Print nothing
  end
end
Minitest::Reporters.use! [MinimalReporter.new]

# This is designed to run against deployed sites to make
# sure everything is all good
# MUST RUN DATA SAFE ACTIONS
class DeploymentTest < ActionDispatch::SystemTestCase
  Capybara.app_host = ENV.fetch('WEBSITE_URL')
  Capybara.run_server = false
  Capybara.default_max_wait_time = 10
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in_with(username, password)
    visit root_path
    assert_text 'Remember me'
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_on 'Sign in'
    assert_text 'Sign out'
  end

  # rubocop:disable Metrics/MethodLength
  def test_sign_in_and_presence_of_table_rows
    username = Rails.application.credentials.jqc_username
    password = Rails.application.credentials.jqc_password
    sign_in_with username, password

    # Column headers
    [
      'Reference number',
      'Location',
      'Suburb',
      'Description',
      'Admin notes',
      'Applicant',
      'Council',
      'Date entered',
      'DA no.'
    ].each { |header| assert_text header }

    # Request Support button shows my email
    click_on 'Request Support'
    assert_text 'mail@tombarone.net'

    # We have a few table rows in there
    assert_text 'Edit', minimum: 10
  end
  # rubocop:enable Metrics/MethodLength
end
