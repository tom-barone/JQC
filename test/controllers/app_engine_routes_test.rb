# frozen_string_literal: true

require 'test_helper'

class ApplicationTypesControllerTest < ActionDispatch::IntegrationTest
  test 'Should correctly handle the start and stop requests from Google App Engine' do
    get '/_ah/start'
    assert_response :success

    get '/_ah/stop'
    assert_response :success
  end
end
