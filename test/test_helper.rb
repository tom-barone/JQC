# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'minitest/reporters'
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new,
                            Minitest::Reporters::JUnitReporter.new('ci/ruby/tests', true, { single_file: true })]
end
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    # include FactoryBot::Syntax::Methods

    # Sign in - only for integration tests
    include Devise::Test::IntegrationHelpers
  end
end
