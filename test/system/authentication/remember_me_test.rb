# frozen_string_literal: true

require 'application_system_test_case'

class RememberMeTest < ApplicationSystemTestCase
  include SignInPageObject

  test 'remember me functionality keeps session active' do
    # Arrange
    visit_sign_in_page

    # Act
    sign_in_with_test_user(remember_me: true)
    assert_signed_in
    delete_session_cookie
    visit applications_path

    # Assert
    assert_signed_in
  end

  test 'no remember me allows session to expire' do
    # Arrange
    visit_sign_in_page

    # Act
    sign_in_with_test_user(remember_me: false)
    assert_signed_in
    delete_session_cookie
    visit applications_path

    # Assert
    assert_signed_out
  end

  test 'session persistence across page refreshes' do
    # Arrange
    visit_sign_in_page
    sign_in_with_test_user
    assert_signed_in

    # Act
    page.driver.browser.navigate.refresh

    # Assert
    assert_signed_in
  end
end
