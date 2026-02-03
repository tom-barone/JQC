# frozen_string_literal: true

require 'application_system_test_case'

module Settings
  class SuburbsTest < ApplicationSystemTestCase
    include Parallelize
    include NavBarPageObject
    include SettingsPageObject

    # Given 5 suburbs exist
    # When the user visits the suburbs settings page
    # Then all 5 suburbs are displayed in the table
    test 'displays all suburbs in the table' do
      suburbs = create_suburbs
      sign_in

      click_settings_link
      click_suburbs_tab

      suburbs.each do |suburb|
        assert_text suburb.suburb
        assert_text suburb.state
        assert_text suburb.postcode
      end
    end

    # Given 15 suburbs exist
    # When the user visits the suburbs settings page
    # Then only 10 suburbs are displayed in the table
    test 'paginates suburbs in the table' do
      15.times do |i|
        # Make sure to 0 pad the name
        create(:suburb, suburb: format('S%02d', i + 1), state: 'SA', postcode: "10#{i + 1}1")
      end
      sign_in

      click_settings_link
      click_suburbs_tab

      10.times do |i|
        assert_text "S#{format('%02d', i + 1)}"
      end
      5.times do |i|
        assert_no_text "S#{format('%02d', i + 11)}"
      end
    end
  end
end
