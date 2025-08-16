# frozen_string_literal: true

require 'application_system_test_case'

class RequestSupportTest < ApplicationSystemTestCase
  include NavBarPageObject

  test 'request support button does not show support details by default' do
    # Arrange
    sign_in
    support_email = Rails.application.credentials.support_email!
    support_phone = Rails.application.credentials.support_phone!
    support_name = "please contact #{Rails.application.credentials.support_name!}"

    # Act

    # Assert
    assert_no_text support_email, exact: false
    assert_no_text support_phone, exact: false
    assert_no_text support_name, exact: false
  end

  test 'request support button shows the correct details when clicked' do
    # Arrange
    sign_in
    support_email = Rails.application.credentials.support_email!
    support_phone = Rails.application.credentials.support_phone!
    support_name = "please contact #{Rails.application.credentials.support_name!}"

    # Act
    click_request_support_button

    # Assert
    assert_text support_email, exact: false
    assert_text support_phone, exact: false
    assert_text support_name, exact: false
  end
end
