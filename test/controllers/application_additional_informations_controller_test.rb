require 'test_helper'

class ApplicationAdditionalInformationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_additional_information = application_additional_informations(:one)
  end

  test "should get index" do
    get application_additional_informations_url
    assert_response :success
  end

  test "should get new" do
    get new_application_additional_information_url
    assert_response :success
  end

  test "should create application_additional_information" do
    assert_difference('ApplicationAdditionalInformation.count') do
      post application_additional_informations_url, params: { application_additional_information: { application_id: @application_additional_information.application_id, info_date: @application_additional_information.info_date, info_text: @application_additional_information.info_text } }
    end

    assert_redirected_to application_additional_information_url(ApplicationAdditionalInformation.last)
  end

  test "should show application_additional_information" do
    get application_additional_information_url(@application_additional_information)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_additional_information_url(@application_additional_information)
    assert_response :success
  end

  test "should update application_additional_information" do
    patch application_additional_information_url(@application_additional_information), params: { application_additional_information: { application_id: @application_additional_information.application_id, info_date: @application_additional_information.info_date, info_text: @application_additional_information.info_text } }
    assert_redirected_to application_additional_information_url(@application_additional_information)
  end

  test "should destroy application_additional_information" do
    assert_difference('ApplicationAdditionalInformation.count', -1) do
      delete application_additional_information_url(@application_additional_information)
    end

    assert_redirected_to application_additional_informations_url
  end
end
