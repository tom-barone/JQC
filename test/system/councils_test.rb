# frozen_string_literal: true
require "application_system_test_case"

class CouncilsTest < ApplicationSystemTestCase
  setup do
    #@council = councils(:one)
  end

  test "visiting the index" do
    skip
    visit councils_url
    assert_selector "h1", text: "Councils"
  end

  test "creating a Council" do
    skip
    visit councils_url
    click_on "New Council"

    fill_in "City", with: @council.city
    fill_in "Email", with: @council.email
    fill_in "Fax", with: @council.fax
    fill_in "Name", with: @council.name
    fill_in "Notes", with: @council.notes
    fill_in "Phone", with: @council.phone
    fill_in "Postal address", with: @council.postal_address
    fill_in "Postal suburb", with: @council.postal_suburb_id
    fill_in "State", with: @council.state
    fill_in "Street", with: @council.street
    fill_in "Suburb", with: @council.suburb_id
    click_on "Create Council"

    assert_text "Council was successfully created"
    click_on "Back"
  end

  test "updating a Council" do
    skip
    visit councils_url
    click_on "Edit", match: :first

    fill_in "City", with: @council.city
    fill_in "Email", with: @council.email
    fill_in "Fax", with: @council.fax
    fill_in "Name", with: @council.name
    fill_in "Notes", with: @council.notes
    fill_in "Phone", with: @council.phone
    fill_in "Postal address", with: @council.postal_address
    fill_in "Postal suburb", with: @council.postal_suburb_id
    fill_in "State", with: @council.state
    fill_in "Street", with: @council.street
    fill_in "Suburb", with: @council.suburb_id
    click_on "Update Council"

    assert_text "Council was successfully updated"
    click_on "Back"
  end

  test "destroying a Council" do
    skip
    visit councils_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Council was successfully destroyed"
  end
end
