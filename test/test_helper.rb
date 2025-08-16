# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    include FactoryBot::Syntax::Methods

    setup do
      redirect_stderr
    end

    teardown do
      restore_stderr
    end

    # Redirect stderr so we don't clutter the test output with warnings
    def redirect_stderr
      log_dir = Rails.root.join('tmp')
      FileUtils.mkdir_p(log_dir)

      @original_stderr = $stderr
      $stderr = File.open(log_dir.join('test_stderr.log'), 'w')
    end

    def restore_stderr
      $stderr = @original_stderr if @original_stderr
    end
  end
end
