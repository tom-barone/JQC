# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # parallelize(workers: :number_of_processors)
    include FactoryBot::Syntax::Methods

    parallelize_setup do |_worker|
      SimpleCov.command_name "Job::#{Process.pid}" if const_defined?(:SimpleCov)
    end

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

# Run tests in parallel with specified workers
# Include this module in your test class to enable parallelization
module Parallelize
  def self.included(base)
    base.class_eval do
      parallelize(workers: :number_of_processors)
    end
  end
end
