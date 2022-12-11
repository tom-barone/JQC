# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
require_relative '../config/environment'
require_relative '../test/browser_test_case'
require 'minitest/autorun'

# Test suite run on production JQC
# MUST RUN DATA SAFE ASSERTIONS
class ProductionTest < BrowserTestCase
  Capybara.app_host = ENV['TEST_HOST'] ||= 'http://localhost:3000'
  Capybara.run_server = false

  def test_the_production_web_server_is_working
    sign_in_test_user

    # Column headers
    [
      'Reference Number',
      'Location',
      'Suburb',
      'Description',
      'Contact',
      'Owner',
      'Applicant',
      'Council',
      'Date Created',
      'DA No.'
    ].each { |header| assert_text header }

    # Request Support button shows my email
    click_on 'Request Support'
    assert_text 'mail@tombarone.net'
    click_on 'Request Support'
    assert_no_text 'mail@tombarone.net'

    # Table values
    assert_text 'Edit', minimum: 10
  end
end
