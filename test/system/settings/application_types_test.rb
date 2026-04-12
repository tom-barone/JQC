# frozen_string_literal: true

require 'application_system_test_case'

module Settings
  class ApplicationTypesTest < ApplicationSystemTestCase
    include Parallelize
    include NavBarPageObject
    include SettingsPageObject

    alias click_save_settings click_save

    include Applications::TablePageObject
    include Applications::EditPageObject

    # Given the user is on the application types settings page
    # When they click Add, fill in the new row, and save
    # Then the new type is created in the database
    test 'creating a new application type via inline add' do
      sign_in
      click_settings_link
      click_add_application_type

      within_new_application_type_row do |row|
        row.find("input[name$='[application_type]']").fill_in with: 'DA'
        row.find("input[name$='[last_used]']").fill_in with: '100'
        row.find("input[name$='[display_priority]']").fill_in with: '1'
      end
      click_save_settings

      assert_current_path '/'

      click_settings_link

      assert_selector "input[value='DA']"
    end

    # Given the user adds a new row but leaves the name blank
    # When they save
    # Then the blank row is ignored and no record is created
    test 'adding a row without a name does not create a record' do
      sign_in
      click_settings_link
      click_add_application_type
      click_save_settings

      assert_equal 0, ApplicationType.count
    end

    # Given the user creates a new active application type via inline add
    # When they visit the new application page
    # Then the new type can be selected in the dropdown
    test 'newly created application type appears in application dropdown' do
      sign_in
      click_settings_link
      click_add_application_type

      within_new_application_type_row do |row|
        row.find("input[name$='[application_type]']").fill_in with: 'DA'
        row.find("input[name$='[last_used]']").fill_in with: '0'
        row.find("input[name$='[display_priority]']").fill_in with: '1'
      end
      click_save_settings

      click_new_application

      assert_application_type_options(%w[DA])
    end

    test 'Given 3 active application types,
          When the user views the new application page,
          Then all 3 application types can be selected' do
      # Arrange
      create(:application_type, :pc, active: true)
      create(:application_type, :q, active: true)
      create(:application_type, :c, active: true)
      sign_in

      # Act
      click_new_application

      # Assert
      assert_application_type_options(%w[PC Q C])
    end

    test 'Given 3 active application types,
          When the user changes an application type to inactive and saves,
          Then the application type cannot be selected' do
      # Arrange
      create(:application_type, :pc, active: true)
      create(:application_type, :q, active: true)
      create(:application_type, :c, active: true)
      sign_in
      click_settings_link

      # Act
      set_active('PC', false)
      click_save_settings
      click_new_application

      # Assert
      assert_application_type_options(%w[Q C])
    end

    test 'Given 2 application types with increasing priorities,
          When looking at the application list,
          Then the higher priority type appears first' do
      # Arrange
      create(:application_type, :pc, display_priority: 1)
      create(:application_type, :q, display_priority: 2)
      create(:pc90_application)
      create(:q90_application)

      # Act
      sign_in

      # Assert
      rows = table_rows_as_hashes

      assert_equal 'PC90', rows.first[:reference_number].text
      assert_equal 'Q90', rows.second[:reference_number].text
    end

    test 'Given 2 application types with increasing priorities,
          When the user switches priorities and saves,
          Then the new highest priority application type appears first in the list' do
      # Arrange
      create(:application_type, :pc, display_priority: 1)
      create(:application_type, :q, display_priority: 2)
      create(:pc90_application)
      create(:q90_application)
      sign_in
      click_settings_link

      # Act
      fill_in_priority('PC', 2)
      fill_in_priority('Q', 1)
      click_save_settings

      # Assert
      rows = table_rows_as_hashes

      assert_equal 'Q90', rows.first[:reference_number].text
      assert_equal 'PC90', rows.second[:reference_number].text
    end
  end
end
