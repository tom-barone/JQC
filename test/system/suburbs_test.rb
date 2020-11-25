require "application_system_test_case"

class SuburbsTest < ApplicationSystemTestCase
  setup do
    @suburb = suburbs(:one)
  end

  test "visiting the index" do
    visit suburbs_url
    assert_selector "h1", text: "Suburbs"
  end

  test "creating a Suburb" do
    visit suburbs_url
    click_on "New Suburb"

    fill_in "Displayname", with: @suburb.DisplayName
    fill_in "Postcode", with: @suburb.Postcode
    fill_in "State", with: @suburb.State
    fill_in "Suburb", with: @suburb.Suburb
    click_on "Create Suburb"

    assert_text "Suburb was successfully created"
    click_on "Back"
  end

  test "updating a Suburb" do
    visit suburbs_url
    click_on "Edit", match: :first

    fill_in "Displayname", with: @suburb.DisplayName
    fill_in "Postcode", with: @suburb.Postcode
    fill_in "State", with: @suburb.State
    fill_in "Suburb", with: @suburb.Suburb
    click_on "Update Suburb"

    assert_text "Suburb was successfully updated"
    click_on "Back"
  end

  test "destroying a Suburb" do
    visit suburbs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Suburb was successfully destroyed"
  end
end
