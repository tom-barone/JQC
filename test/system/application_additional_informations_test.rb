require "application_system_test_case"

class ApplicationAdditionalInformationsTest < ApplicationSystemTestCase
  setup do
    @application_additional_information = application_additional_informations(:one)
  end

  test "visiting the index" do
    visit application_additional_informations_url
    assert_selector "h1", text: "Application Additional Informations"
  end

  test "creating a Application additional information" do
    visit application_additional_informations_url
    click_on "New Application Additional Information"

    fill_in "Application", with: @application_additional_information.application_id
    fill_in "Info date", with: @application_additional_information.info_date
    fill_in "Info text", with: @application_additional_information.info_text
    click_on "Create Application additional information"

    assert_text "Application additional information was successfully created"
    click_on "Back"
  end

  test "updating a Application additional information" do
    visit application_additional_informations_url
    click_on "Edit", match: :first

    fill_in "Application", with: @application_additional_information.application_id
    fill_in "Info date", with: @application_additional_information.info_date
    fill_in "Info text", with: @application_additional_information.info_text
    click_on "Update Application additional information"

    assert_text "Application additional information was successfully updated"
    click_on "Back"
  end

  test "destroying a Application additional information" do
    visit application_additional_informations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Application additional information was successfully destroyed"
  end
end
