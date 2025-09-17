# frozen_string_literal: true

require 'application_system_test_case'
require 'faker'

class AdminAndInvoicingBasicFieldsTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::TablePageObject
  include Applications::EditPageObject

  INPUTS = {
    da_number: Faker::Alphanumeric.alphanumeric(number: 8).upcase,
    number_of_storeys: Faker::Number.between(from: 1, to: 10).to_s,
    construction_value: Faker::Number.decimal(l_digits: 6, r_digits: 1).to_s,
    area: Faker::Number.decimal(l_digits: 3, r_digits: 1).to_s,
    fee_amount: Faker::Number.decimal(l_digits: 5, r_digits: 1).to_s,
    applicant_email: Faker::Internet.email,
    lot_number: Faker::Address.building_number,
    street_number: Faker::Address.building_number,
    street_name: Faker::Address.street_name,
    quote_accepted_date: Faker::Date.between(from: '2023-01-01', to: '2023-12-31'),
    description: Faker::Lorem.sentence(word_count: 10),
    administration_notes: Faker::Lorem.sentence(word_count: 10),
    invoice_to: Faker::Name.name,
    care_of: Faker::Name.name,
    invoice_email: Faker::Internet.email,
    attention: Faker::Name.name,
    purchase_order_number: Faker::Number.number(digits: 8).to_s,
    invoice_debtor_notes: Faker::Lorem.sentence(word_count: 10)
  }.freeze

  CHECKBOXES = {
    kd_to_lodge: Faker::Boolean.boolean,
    staged_consent: Faker::Boolean.boolean,
    engagement_form: Faker::Boolean.boolean,
    cancelled: Faker::Boolean.boolean
  }.freeze

  SELECTS = {
    job_type_administration: Application::JOB_TYPE_ADMINISTRATION.sample
  }.freeze

  # Tests for creating a new application, setting a simple field and checking it has been saved
  INPUTS.each do |field, value|
    test "can create a new application and set #{field}" do
      # Arrange
      create_new_pc124_and_set_default_fields

      # Act
      send("fill_in_#{field}", value)
      click_save

      # Assert
      assert_no_current_path new_application_path
      click_on 'PC124'
      send("assert_#{field}", value)
    end
  end

  CHECKBOXES.each do |field, checked|
    test "can create a new application and set the #{field} checkbox" do
      # Arrange
      create_new_pc124_and_set_default_fields

      # Act
      send("set_#{field}", checked)
      click_save

      # Assert
      assert_no_current_path new_application_path
      click_on 'PC124'
      send("assert_#{field}", checked)
    end
  end

  SELECTS.each do |field, value|
    test "can create a new application and set #{field}" do
      # Arrange
      create_new_pc124_and_set_default_fields

      # Act
      send("select_#{field}", value)
      click_save

      # Assert
      assert_no_current_path new_application_path
      click_on 'PC124'
      send("assert_#{field}", value)
    end
  end
end
