# frozen_string_literal: true
require "application_system_test_case"

class ApplicationTypesTest < ApplicationSystemTestCase
  setup do
    #@application_type = application_types(:one)
  end

  test "visiting the index" do
    skip
    visit application_types_url
    assert_selector "h1", text: "Application Types"
  end

  test "creating a Application type" do
    skip
    visit application_types_url
    click_on "New Application Type"

    fill_in "Last used", with: @application_type.last_used
    click_on "Create Application type"

    assert_text "Application type was successfully created"
    click_on "Back"
  end

  test "updating a Application type" do
    skip
    visit application_types_url
    click_on "Edit", match: :first

    fill_in "Last used", with: @application_type.last_used
    click_on "Update Application type"

    assert_text "Application type was successfully updated"
    click_on "Back"
  end

  test "destroying a Application type" do
    skip
    visit application_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Application type was successfully destroyed"
  end
end
