# frozen_string_literal: true

require 'application_system_test_case'

class CreateApplicationTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::TablePageObject
  include Applications::EditPageObject

  test 'can click to create a new application' do
    # Arrange
    sign_in

    # Act
    click_new_application

    # Assert
    assert_text 'Administration & Invoicing'
  end

  test 'choosing between application types sets the reference number correctly' do
    # Arrange
    create(:application_type, :pc, last_used: 123)
    create(:application_type, :q, last_used: 444)
    sign_in

    # Act
    click_new_application
    select_application_type('PC')
    select_application_type('Q')
    select_application_type('PC')

    # Assert
    assert_reference_number 'PC124'
  end

  test 'discarding a new application and creating a new one does not change the last used reference number' do
    # Arrange
    create(:application_type, :pc, last_used: 123)
    sign_in

    # Act
    click_new_application
    select_application_type('PC')

    assert_reference_number 'PC124'

    click_and_confirm_exit
    click_new_application
    select_application_type('PC')

    # Assert
    assert_reference_number 'PC124'
  end

  test 'a new application cannot be saved without appropriate fields filled in' do
    # Arrange
    sign_in

    # Act
    click_new_application
    click_save

    # Assert
    assert_current_path new_application_path # No successful save
  end

  test 'a new application cannot be saved without an application type' do
    # Arrange
    sign_in

    # Act
    click_new_application
    fill_in_reference_number('Test123')
    fill_in_date_entered(Date.current)
    click_save

    # Assert
    assert_current_path new_application_path # No successful save
  end

  test 'a new application cannot be saved without a reference number' do
    # Arrange
    create_application_types
    sign_in

    # Act
    click_new_application
    select_application_type('PC')
    fill_in_reference_number('') # Clear the auto-filled reference number
    fill_in_date_entered(Date.current)
    click_save

    # Assert
    assert_current_path new_application_path # No successful save
  end

  test 'a new application cannot be saved without date entered' do
    # Arrange
    create_application_types
    sign_in

    # Act
    click_new_application
    select_application_type('PC') # Auto sets the reference number
    click_save

    # Assert
    assert_current_path new_application_path # No successful save
  end

  test 'if there are form changes on a new application, confirmation is required when exiting' do
    # Arrange
    create_application_types
    sign_in

    # Act
    click_new_application
    select_application_type('PC')
    click_exit

    # Assert
    assert_current_path new_application_path
    assert_text 'All unsaved changes will be discarded.'
  end

  test 'if there are no form changes on a new application, no confirmation is required when exiting' do
    # Arrange
    create_application_types
    sign_in

    # Act
    click_new_application
    click_exit

    # Assert
    assert_no_current_path new_application_path
  end
end
