# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesEditTest < ApplicationSystemTestCase
  def assert_original_settings
    assert_settings_application_type('C',  at: 0)
    assert_settings_application_type('LG', at: 1)
    assert_settings_application_type('PC', at: 2)
    assert_settings_application_type('Q',  at: 3)
    assert_settings_application_type('RC', at: 4)
    assert_settings_application_type('SC', at: 5)
    assert_settings_last_used('7002', at: 0)
    assert_settings_last_used('6002', at: 1)
    assert_settings_last_used('9002', at: 2)
    assert_settings_last_used('8002', at: 3)
    assert_settings_last_used('2090', at: 4)
    assert_settings_last_used('428',  at: 5)
  end

  test 'editing and saving last used numbers' do
    sign_in_test_user

    go_to_settings_page
    assert_on_settings_page
    assert_original_settings

    # Save without changes
    save_settings
    assert_not_on_settings_page
    assert_on_homepage

    # Go back and check nothing changed
    go_to_settings_page
    assert_on_settings_page
    assert_original_settings

    # Make some changes but then exit without saving
    update_settings_last_used('1234',   at: 0)
    update_settings_last_used('',       at: 1)
    update_settings_last_used('zxcvzx', at: 2)
    update_settings_last_used('9999',   at: 3)
    update_settings_last_used('2090',   at: 4)
    update_settings_last_used('0',      at: 5)
    exit_settings
    assert_not_on_settings_page
    assert_on_homepage

    # Make some changes and save
    go_to_settings_page
    assert_on_settings_page
    assert_original_settings
    update_settings_last_used('1234',   at: 0)
    update_settings_last_used('',       at: 1)
    update_settings_last_used('zxcvzx', at: 2)
    update_settings_last_used('9999',   at: 3)
    update_settings_last_used('2090',   at: 4)
    update_settings_last_used('0',      at: 5)
    save_settings

    # Check saved changes
    assert_on_homepage
    go_to_settings_page
    assert_settings_last_used('1234', at: 0)
    assert_settings_last_used('6002', at: 1)
    assert_settings_last_used('9002', at: 2)
    assert_settings_last_used('9999', at: 3)
    assert_settings_last_used('2090', at: 4)
    assert_settings_last_used('0',    at: 5)
  end
end
