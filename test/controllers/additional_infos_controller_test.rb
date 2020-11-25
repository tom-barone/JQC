require 'test_helper'

class AdditionalInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @additional_info = additional_infos(:one)
  end

  test "should get index" do
    get additional_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_additional_info_url
    assert_response :success
  end

  test "should create additional_info" do
    assert_difference('AdditionalInfo.count') do
      post additional_infos_url, params: { additional_info: { ApplicationID_id: @additional_info.ApplicationID_id, InfoDate: @additional_info.InfoDate, InfoText: @additional_info.InfoText } }
    end

    assert_redirected_to additional_info_url(AdditionalInfo.last)
  end

  test "should show additional_info" do
    get additional_info_url(@additional_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_additional_info_url(@additional_info)
    assert_response :success
  end

  test "should update additional_info" do
    patch additional_info_url(@additional_info), params: { additional_info: { ApplicationID_id: @additional_info.ApplicationID_id, InfoDate: @additional_info.InfoDate, InfoText: @additional_info.InfoText } }
    assert_redirected_to additional_info_url(@additional_info)
  end

  test "should destroy additional_info" do
    assert_difference('AdditionalInfo.count', -1) do
      delete additional_info_url(@additional_info)
    end

    assert_redirected_to additional_infos_url
  end
end
