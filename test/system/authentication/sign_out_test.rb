# frozen_string_literal: true

require 'application_system_test_case'

class SignOutTest < ApplicationSystemTestCase
  include SignInPageObject
  include NavBarPageObject

  test 'logout functionality' do
    # Arrange
    sign_in

    # Act
    click_sign_out_button

    # Assert
    assert_signed_out
    assert_text 'Signed out successfully.'
  end
end
