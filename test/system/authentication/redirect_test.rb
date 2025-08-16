# frozen_string_literal: true

require 'application_system_test_case'

class RedirectTest < ApplicationSystemTestCase
  include SignInPageObject

  test 'redirect to login when accessing protected routes while unauthenticated' do
    # Act & Assert
    visit applications_path

    assert_signed_out

    visit new_application_path

    assert_signed_out
  end

  test 'redirect to originally requested page after successful login' do
    # Arrange
    user = create(:user)
    visit new_application_path

    assert_signed_out

    # Act
    sign_in_with(user)

    # Assert
    assert_current_path new_application_path
  end
end
