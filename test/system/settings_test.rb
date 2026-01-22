# frozen_string_literal: true

require 'application_system_test_case'

class SettingsTest < ApplicationSystemTestCase
  include Parallelize
  include NavBarPageObject
  include SettingsPageObject

  alias click_save_settings click_save

  include Applications::TablePageObject
  include Applications::EditPageObject

  test 'Given 3 active application types,
        When the user changes an application type to inactive and saves,
        Then the application type cannot be selected' do
    # Arrange
    create(:application_type, :pc, last_used: 123, active: true)
    create(:application_type, :q, last_used: 444, active: true)
    create(:application_type, :c, last_used: 121, active: true)
    sign_in
    click_settings_link

    # Act
    set_active('PC', false)
    click_save_settings
    click_new_application

    # Assert
    assert_application_type_options(%w[Q C])
  end
end
