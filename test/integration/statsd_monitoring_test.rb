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
    assert_statsd_measure('http.request.duration') do
      get rails_health_check_path
    end

    assert_response :success
  end

  test 'tracks HTTP status code for successful requests' do
    assert_statsd_increment('http.request.status', tags: ['status:200', 'type:application']) do
      get rails_health_check_path
    end

    assert_response :success
  end

  test 'tracks HTTP status code for not found requests' do
    assert_statsd_increment('http.request.status', tags: ['status:404', 'type:application']) do
      get '/nonexistent-path'
    end

    assert_response :not_found
  end

  test 'tracks request duration for authenticated routes' do
    sign_in users(:test_user)

    assert_statsd_measure('http.request.duration') do
      get applications_path
    end

    assert_response :success
  end

  test 'tracks HTTP status code for unauthorized requests' do
    assert_statsd_increment('http.request.status', tags: ['status:302', 'type:application']) do
      get applications_path
    end

    assert_redirected_to new_user_session_path
  end

  test 'includes controller and action tags in metrics' do
    assert_statsd_measure('http.request.duration',
                          tags: ['controller:health', 'action:show', 'type:application']) do
      get rails_health_check_path
    end

    assert_response :success
  end

  test 'tracks request method in metrics' do
    sign_in users(:test_user)

    assert_statsd_increment('http.request.status',
                            tags: ['status:200', 'method:GET', 'type:application']) do
      get applications_path
    end

    assert_response :success
  end

  test 'tracks POST requests with status codes' do
    sign_in users(:test_user)

    assert_statsd_increment('http.request.status',
                            tags: ['status:404', 'method:POST', 'type:application']) do
      # Test POST to a non-existent route to get 404
      post '/nonexistent-route'
    end

    assert_response :not_found
  end

  test 'tags asset requests appropriately' do
    assert_statsd_increment('http.request.status',
                            tags: ['status:404', 'method:GET', 'type:asset', 'asset_type:stylesheet']) do
      get '/assets/nonexistent.css'
    end

    assert_response :not_found
  end

  test 'tags JavaScript asset requests' do
    assert_statsd_increment('http.request.status',
                            tags: ['status:404', 'method:GET', 'type:asset', 'asset_type:javascript']) do
      get '/assets/nonexistent.js'
    end

    assert_response :not_found
  end

  test 'tags image asset requests' do
    assert_statsd_increment('http.request.status',
                            tags: ['status:404', 'method:GET', 'type:asset', 'asset_type:image']) do
      get '/assets/nonexistent.png'
    end

    assert_response :not_found
  end
end
