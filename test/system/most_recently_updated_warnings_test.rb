# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
  test 'Applications with no conversions do not show warnings or links' do
    sign_in_test_user

    self.homepage_search_type = 'Q'
    homepage_search
    edit_application 'Q8001'

    assert_no_go_to_conversion_button
    assert_no_more_recent_conversion_warning

    self.application_type = 'PC'
    assert_no_go_to_conversion_button
    assert_no_more_recent_conversion_warning
    save_application

    # Get the newly created PC
    self.homepage_search_type = 'PC'
    homepage_search
    edit_application 'PC9003'
    assert_go_to_conversion_button
    assert_no_more_recent_conversion_warning
    exit_application

    self.homepage_search_type = 'Q'
    homepage_search
    edit_application 'Q8001'
    assert_go_to_conversion_button
    assert_more_recent_conversion_warning 'PC9003'

    click_on_conversion_warning_link 'PC9003'
    assert_application_reference_number 'PC9003'
    assert_application_converted_to_from 'Q8001'
    assert_no_more_recent_conversion_warning

    click_on_go_to_conversion_button
    assert_application_reference_number 'Q8001'
    assert_application_converted_to_from 'PC9003'
    assert_more_recent_conversion_warning 'PC9003'

    exit_application
    assert_on_homepage
  end

  test 'Applications with conversions show correct warnings and links' do
    sign_in_test_user
    new_app = applications(:application_PC1)
    old_app = applications(:application_PC2)
    new_app.update!(converted_to_from: old_app.reference_number, updated_at: Time.zone.now - 10.minutes)
    old_app.update!(converted_to_from: new_app.reference_number, updated_at: Time.zone.now - 20.minutes)

    edit_application new_app.reference_number
    assert_no_more_recent_conversion_warning
    assert_go_to_conversion_button
    exit_application
    assert_on_homepage

    edit_application old_app.reference_number
    assert_more_recent_conversion_warning new_app.reference_number
    assert_go_to_conversion_button
    self.application_description = 'something new'
    save_application
    assert_on_homepage

    edit_application new_app.reference_number
    assert_more_recent_conversion_warning old_app.reference_number
    assert_go_to_conversion_button
    exit_application
    assert_on_homepage

    edit_application old_app.reference_number
    assert_no_more_recent_conversion_warning
    assert_go_to_conversion_button
  end
end
