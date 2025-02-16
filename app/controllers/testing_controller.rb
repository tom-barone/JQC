# frozen_string_literal: true

class TestingController < ApplicationController
  # GET /fail
  # Used for testing exception notifications
  # Only available in development and test environments
  def fail
    raise SyntaxError, 'I should send an exception notification email'
  end
end
