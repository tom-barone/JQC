# frozen_string_literal: true
require 'test_helper'

class SuburbsControllerTest < ActionDispatch::IntegrationTest
  setup do
    #sign_in_test_user
    #@suburb = suburbs(:one)
    #@unused = suburbs(:unused)
  end

  test "should get index" do
    skip
    get suburbs_url
    assert_response :success
  end

  test "should get new" do
    skip
    get new_suburb_url
    assert_response :success
  end

  test "should create suburb" do
    skip
    assert_difference('Suburb.count') do
      post suburbs_url, params: { suburb: { display_name: @suburb.display_name, postcode: @suburb.postcode, state: @suburb.state, suburb: @suburb.suburb } }
    end

    assert_redirected_to suburb_url(Suburb.last)
  end

  test "should show suburb" do
    skip
    get suburb_url(@suburb)
    assert_response :success
  end

  test "should get edit" do
    skip
    get edit_suburb_url(@suburb)
    assert_response :success
  end

  test "should update suburb" do
    skip
    patch suburb_url(@suburb), params: { suburb: { display_name: @suburb.display_name, postcode: @suburb.postcode, state: @suburb.state, suburb: @suburb.suburb } }
    assert_redirected_to suburb_url(@suburb)
  end

  test "should destroy suburb" do
    skip
    assert_difference('Suburb.count', -1) do
      delete suburb_url(@unused)
    end

    assert_redirected_to suburbs_url
  end
end
