require 'test_helper'

class ApplicationTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    #sign_in_test_user
    #@application_type = application_types(:one)
    #@unused = application_types(:unused)
  end

  test "should get index" do
    skip
    get application_types_url
    assert_response :success
  end

  test "should get new" do
    skip
    get new_application_type_url
    assert_response :success
  end

  test "should create application_type" do
    skip
    assert_difference('ApplicationType.count') do
      post application_types_url, params: { application_type: { application_type: @application_type.application_type, last_used: @application_type.last_used } }
    end

    assert_redirected_to application_type_url(ApplicationType.last)
  end

  test "should show application_type" do
    skip
    get application_type_url(@application_type)
    assert_response :success
  end

  test "should get edit" do
    skip
    get edit_application_type_url(@application_type)
    assert_response :success
  end

  test "should update application_type" do
    skip
    patch application_type_url(@application_type), params: { application_type: { application_type: @application_type.application_type, last_used: @application_type.last_used } }
    assert_redirected_to application_type_url(@application_type)
  end

  test "should destroy application_type" do
    skip
    assert_difference('ApplicationType.count', -1) do
      delete application_type_url(@unused)
    end

    assert_redirected_to application_types_url
  end
  
end
