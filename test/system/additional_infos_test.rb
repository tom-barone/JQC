require "application_system_test_case"

class AdditionalInfosTest < ApplicationSystemTestCase
  setup do
    @additional_info = additional_infos(:one)
  end

  test "visiting the index" do
    visit additional_infos_url
    assert_selector "h1", text: "Additional Infos"
  end

  test "creating a Additional info" do
    visit additional_infos_url
    click_on "New Additional Info"

    fill_in "Applicationid", with: @additional_info.ApplicationID_id
    fill_in "Infodate", with: @additional_info.InfoDate
    fill_in "Infotext", with: @additional_info.InfoText
    click_on "Create Additional info"

    assert_text "Additional info was successfully created"
    click_on "Back"
  end

  test "updating a Additional info" do
    visit additional_infos_url
    click_on "Edit", match: :first

    fill_in "Applicationid", with: @additional_info.ApplicationID_id
    fill_in "Infodate", with: @additional_info.InfoDate
    fill_in "Infotext", with: @additional_info.InfoText
    click_on "Update Additional info"

    assert_text "Additional info was successfully updated"
    click_on "Back"
  end

  test "destroying a Additional info" do
    visit additional_infos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Additional info was successfully destroyed"
  end
end
