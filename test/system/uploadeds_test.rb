require "application_system_test_case"

class UploadedsTest < ApplicationSystemTestCase
  setup do
    @uploaded = uploadeds(:one)
  end

  test "visiting the index" do
    visit uploadeds_url
    assert_selector "h1", text: "Uploadeds"
  end

  test "creating a Uploaded" do
    visit uploadeds_url
    click_on "New Uploaded"

    fill_in "Applicationid", with: @uploaded.ApplicationID_id
    fill_in "Uploadeddate", with: @uploaded.UploadedDate
    fill_in "Uploadedtext", with: @uploaded.UploadedText
    click_on "Create Uploaded"

    assert_text "Uploaded was successfully created"
    click_on "Back"
  end

  test "updating a Uploaded" do
    visit uploadeds_url
    click_on "Edit", match: :first

    fill_in "Applicationid", with: @uploaded.ApplicationID_id
    fill_in "Uploadeddate", with: @uploaded.UploadedDate
    fill_in "Uploadedtext", with: @uploaded.UploadedText
    click_on "Update Uploaded"

    assert_text "Uploaded was successfully updated"
    click_on "Back"
  end

  test "destroying a Uploaded" do
    visit uploadeds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Uploaded was successfully destroyed"
  end
end
