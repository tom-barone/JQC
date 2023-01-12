# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTableTest < ApplicationSystemTestCase
  test 'the uploaded fields are disabled when there is no Risk Rating set' do
    sign_in_test_user
    edit_application 'PC9001'
    assert_on_application_edit_page
    # add 2 new uploaded fields
    application_uploaded_click_add
    application_uploaded_click_add
    # Check they are disabled, because no risk rating is set
    assert_application_uploaded_disabled(count: 2)

    # Add risk rating and check the fields are enabled
    self.application_risk_rating = 'High'
    assert_no_application_uploaded_disabled

    # Set two new fields and save
    application_remove_uploaded
    application_remove_uploaded
    application_add_uploaded(Date.new(2022, 10, 4), 'COO')
    application_add_uploaded(Date.new(2023, 10, 4), 'Variation')
    save_application
    assert_on_homepage

    # Open again check if still enabled
    edit_application 'PC9001'
    assert_on_application_edit_page
    assert_no_application_uploaded_disabled

    # Remove risk rating and check the fields are disabled
    self.application_risk_rating = ''
    application_uploaded_click_add
    assert_application_uploaded_disabled(count: 1)
    assert_application_uploaded('2022-10-04', 'COO', at: 0, disabled: true)
    assert_application_uploaded('2023-10-04', 'Variation', at: 1, disabled: true)
  end
end
