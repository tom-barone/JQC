require 'test_helper'

class UploadedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @uploaded = uploadeds(:one)
  end

  test "should get index" do
    get uploadeds_url
    assert_response :success
  end

  test "should get new" do
    get new_uploaded_url
    assert_response :success
  end

  test "should create uploaded" do
    assert_difference('Uploaded.count') do
      post uploadeds_url, params: { uploaded: { ApplicationID_id: @uploaded.ApplicationID_id, UploadedDate: @uploaded.UploadedDate, UploadedText: @uploaded.UploadedText } }
    end

    assert_redirected_to uploaded_url(Uploaded.last)
  end

  test "should show uploaded" do
    get uploaded_url(@uploaded)
    assert_response :success
  end

  test "should get edit" do
    get edit_uploaded_url(@uploaded)
    assert_response :success
  end

  test "should update uploaded" do
    patch uploaded_url(@uploaded), params: { uploaded: { ApplicationID_id: @uploaded.ApplicationID_id, UploadedDate: @uploaded.UploadedDate, UploadedText: @uploaded.UploadedText } }
    assert_redirected_to uploaded_url(@uploaded)
  end

  test "should destroy uploaded" do
    assert_difference('Uploaded.count', -1) do
      delete uploaded_url(@uploaded)
    end

    assert_redirected_to uploadeds_url
  end
end
