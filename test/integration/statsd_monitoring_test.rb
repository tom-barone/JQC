# frozen_string_literal: true

require 'test_helper'

class StatsdMonitoringTest < ActionDispatch::IntegrationTest
  include StatsD::Instrument::Assertions
  include Devise::Test::IntegrationHelpers

  setup do
    # Reset captured metrics before each test
    StatsD.singleton_client.sink.clear if StatsD.singleton_client.sink.respond_to?(:clear)
  end

  test 'tracks request duration for successful requests' do
    assert_statsd_measure('http.request.duration.get.2xx') do
      get rails_health_check_path
    end

    assert_response :success
  end

  test 'tracks HTTP status code for successful requests' do
    assert_statsd_increment('http.request.status.200') do
      get rails_health_check_path
    end

    assert_response :success
  end

  test 'tracks HTTP status code for not found requests' do
    assert_statsd_increment('http.request.status.404') do
      get '/nonexistent-path'
    end

    assert_response :not_found
  end

  test 'tracks request duration for authenticated routes' do
    sign_in users(:test_user)

    assert_statsd_measure('http.request.duration.get.2xx') do
      get applications_path
    end

    assert_response :success
  end

  test 'tracks HTTP status code for unauthorized requests' do
    assert_statsd_increment('http.request.status.302') do
      get applications_path
    end

    assert_redirected_to new_user_session_path
  end

  test 'includes controller and action in detailed metrics' do
    assert_statsd_measure('http.request.duration.get.2xx.app.health.show') do
      get rails_health_check_path
    end

    assert_response :success
  end

  test 'tracks request method in metrics' do
    sign_in users(:test_user)

    assert_statsd_increment('http.request.status.200') do
      get applications_path
    end

    assert_response :success
  end

  test 'tracks POST requests with status codes' do
    sign_in users(:test_user)

    assert_statsd_increment('http.request.status.404') do
      # Test POST to a non-existent route to get 404
      post '/nonexistent-route'
    end

    assert_response :not_found
  end

  test 'tracks asset requests appropriately' do
    assert_statsd_increment('http.request.status.404') do
      get '/assets/nonexistent.css'
    end

    assert_response :not_found
  end

  test 'tracks JavaScript asset requests' do
    assert_statsd_increment('http.request.status.404') do
      get '/assets/nonexistent.js'
    end

    assert_response :not_found
  end

  test 'tracks image asset requests' do
    assert_statsd_increment('http.request.status.404') do
      get '/assets/nonexistent.png'
    end

    assert_response :not_found
  end
end
