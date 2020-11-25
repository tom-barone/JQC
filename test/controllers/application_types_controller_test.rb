require 'test_helper'

class ApplicationTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_type = application_types(:one)
  end

  test "should get index" do
    get application_types_url
    assert_response :success
  end

  test "should get new" do
    get new_application_type_url
    assert_response :success
  end

  test "should create application_type" do
    assert_difference('ApplicationType.count') do
      post application_types_url, params: { application_type: { LastUsed: @application_type.LastUsed } }
    end

    assert_redirected_to application_type_url(ApplicationType.last)
  end

  test "should show application_type" do
    get application_type_url(@application_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_type_url(@application_type)
    assert_response :success
  end

  test "should update application_type" do
    patch application_type_url(@application_type), params: { application_type: { LastUsed: @application_type.LastUsed } }
    assert_redirected_to application_type_url(@application_type)
  end

  test "should destroy application_type" do
    assert_difference('ApplicationType.count', -1) do
      delete application_type_url(@application_type)
    end

    assert_redirected_to application_types_url
  end
end
