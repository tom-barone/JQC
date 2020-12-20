require 'test_helper'

class ApplicationUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_upload = application_uploads(:one)
  end

  test "should get index" do
    get application_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_application_upload_url
    assert_response :success
  end

  test "should create application_upload" do
    assert_difference('ApplicationUpload.count') do
      post application_uploads_url, params: { application_upload: { application_id: @application_upload.application_id, uploaded_date: @application_upload.uploaded_date, uploaded_text: @application_upload.uploaded_text } }
    end

    assert_redirected_to application_upload_url(ApplicationUpload.last)
  end

  test "should show application_upload" do
    get application_upload_url(@application_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_upload_url(@application_upload)
    assert_response :success
  end

  test "should update application_upload" do
    patch application_upload_url(@application_upload), params: { application_upload: { application_id: @application_upload.application_id, uploaded_date: @application_upload.uploaded_date, uploaded_text: @application_upload.uploaded_text } }
    assert_redirected_to application_upload_url(@application_upload)
  end

  test "should destroy application_upload" do
    assert_difference('ApplicationUpload.count', -1) do
      delete application_upload_url(@application_upload)
    end

    assert_redirected_to application_uploads_url
  end
end
