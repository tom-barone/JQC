require "application_system_test_case"

class CouncilsTest < ApplicationSystemTestCase
  setup do
    @council = councils(:one)
  end

  test "visiting the index" do
    visit councils_url
    assert_selector "h1", text: "Councils"
  end

  test "creating a Council" do
    visit councils_url
    click_on "New Council"

    fill_in "City", with: @council.City
    fill_in "Email", with: @council.Email
    fill_in "Fax", with: @council.Fax
    fill_in "Name", with: @council.Name
    fill_in "Notes", with: @council.Notes
    fill_in "Phone", with: @council.Phone
    fill_in "Postaladdress", with: @council.PostalAddress
    fill_in "Postalsuburbid", with: @council.PostalSuburbID_id
    fill_in "State", with: @council.State
    fill_in "Street", with: @council.Street
    fill_in "Suburbid", with: @council.SuburbID_id
    click_on "Create Council"

    assert_text "Council was successfully created"
    click_on "Back"
  end

  test "updating a Council" do
    visit councils_url
    click_on "Edit", match: :first

    fill_in "City", with: @council.City
    fill_in "Email", with: @council.Email
    fill_in "Fax", with: @council.Fax
    fill_in "Name", with: @council.Name
    fill_in "Notes", with: @council.Notes
    fill_in "Phone", with: @council.Phone
    fill_in "Postaladdress", with: @council.PostalAddress
    fill_in "Postalsuburbid", with: @council.PostalSuburbID_id
    fill_in "State", with: @council.State
    fill_in "Street", with: @council.Street
    fill_in "Suburbid", with: @council.SuburbID_id
    click_on "Update Council"

    assert_text "Council was successfully updated"
    click_on "Back"
  end

  test "destroying a Council" do
    visit councils_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Council was successfully destroyed"
  end
end
