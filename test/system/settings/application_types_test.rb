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
