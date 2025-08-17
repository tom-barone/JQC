# frozen_string_literal: true

require 'application_system_test_case'

class CreateApplicationTest < ApplicationSystemTestCase
  # For SOME REASON this suite can't be parallelized because it messes with
  # the "Are you sure you want to exit?" confirmation dialog.
  # include Parallelize
  include Applications::TablePageObject
  include Applications::EditPageObject

  test 'can click to create a new application' do
    # Arrange
    sign_in

    # Act
    click_new_application

    # Assert
    assert_current_path new_application_path
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
    assert_field REFERENCE_NUMBER_FIELD, with: 'PC124'
  end

  test 'discarding a new application and creating a new one does not change the last used reference number' do
    # Arrange
    create(:application_type, :pc, last_used: 123)
    sign_in

    # Act
    click_new_application
    select_application_type('PC')

    assert_field REFERENCE_NUMBER_FIELD, with: 'PC124'

    click_and_confirm_exit
    click_new_application
    select_application_type('PC')

    # Assert
    assert_field REFERENCE_NUMBER_FIELD, with: 'PC124'
  end
end
