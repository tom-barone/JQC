# frozen_string_literal: true

require 'application_system_test_case'
require 'faker'

class AdminAndInvoicingSuburbTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::TablePageObject
  include Applications::EditPageObject

  def create_new_pc124_and_set_default_fields
    create(:application_type, :pc, last_used: 123)
    sign_in
    click_new_application
    select_application_type('PC')
    fill_in_date_entered(Date.current)
  end

  test 'can create a new application with a suburb' do
    # Arrange
    create(:suburb, suburb: 'TEST', state: 'SA', postcode: '5123')
    create_new_pc124_and_set_default_fields

    # Act
    fill_in_suburb('TEST, SA 5123')
    click_save

    # Assert
    assert_no_current_path new_application_path
    click_on 'PC124'

    assert_suburb 'TEST, SA 5123'
  end

  test 'cannot save a new application if the suburb does not exist' do
    # Arrange
    create(:suburb, suburb: 'TEST', state: 'SA', postcode: '5123')
    create_new_pc124_and_set_default_fields

    # Act
    fill_in_suburb('OTHER, SA 5123')
    click_save

    # Assert
    assert_current_path new_application_path
  end
end
