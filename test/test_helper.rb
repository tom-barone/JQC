# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #include FactoryBot::Syntax::Methods

  # Sign in - only for integration tests
  include Devise::Test::IntegrationHelpers
  def sign_in_test_user
    get '/users/sign_in'
    sign_in users(:test_user)
    post user_session_url
    follow_redirect!
    assert_response :success
  end
end
