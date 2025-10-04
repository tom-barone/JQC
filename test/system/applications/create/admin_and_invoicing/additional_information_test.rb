# frozen_string_literal: true

require 'application_system_test_case'
require 'faker'

class AdminAndInvoicingAdditionalInformationTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::TablePageObject
  include Applications::EditPageObject

  FIELDS = {
    info_date: Faker::Date.between(from: '2024-01-01', to: '2024-12-31'),
    info_text: Faker::Lorem.sentence(word_count: 5)
  }.freeze

  FIELDS.each do |field, value|
    test "can create a new application with a single additional information and set #{field}" do
      # Arrange
      create_new_pc124_and_set_default_fields

      # Act
      click_add_additional_information
      send("all_#{field}").last.fill_in with: value
      click_save

      # Assert
      assert_no_current_path new_application_path
      click_on 'PC124'
      el = send("all_#{field}").last

      assert_field el[:id], with: value
    end
  end

  test 'can create a new application with multiple additional informations' do
    # Arrange
    create_new_pc124_and_set_default_fields

    # Act
    click_add_additional_information
    click_add_additional_information
    all_info_date.first.fill_in with: Date.new(2024, 7, 1)
    all_info_date.last.fill_in with: Date.new(2024, 6, 1)
    click_save

    # Assert
    assert_no_current_path new_application_path
    click_on 'PC124'

    assert_field all_info_date.first[:id], with: Date.new(2024, 7, 1)
    assert_field all_info_date.last[:id], with: Date.new(2024, 6, 1)
  end

  test 'can create a new application with multiple additional informations that are ordered latest at the top' do
    # Arrange
    create_new_pc124_and_set_default_fields

    # Act
    click_add_additional_information
    click_add_additional_information
    all_info_date.first.fill_in with: Date.new(2024, 6, 1)
    all_info_date.last.fill_in with: Date.new(2024, 7, 1)
    click_save

    # Assert
    assert_no_current_path new_application_path
    click_on 'PC124'

    # Latest dates are shown first
    assert_field all_info_date.first[:id], with: Date.new(2024, 7, 1)
    assert_field all_info_date.last[:id], with: Date.new(2024, 6, 1)
  end
end
