# frozen_string_literal: true

require 'application_system_test_case'

class SignInTest < ApplicationSystemTestCase
  include SignInPageObject

  test 'successful login with valid credentials' do
    # Arrange
    visit_sign_in_page

    # Act
    sign_in_with_test_user

    # Assert
    assert_signed_in
  end

  test 'failed login with invalid username' do
    # Arrange
    visit_sign_in_page

    # Act
    sign_in_with_wrong_username

    # Assert
    assert_signed_out
    assert_text 'Invalid username or password.'
  end

  test 'failed login with invalid password' do
    # Arrange
    visit_sign_in_page

    # Act
    sign_in_with_wrong_password

    # Assert
    assert_signed_out
    assert_text 'Invalid username or password.'
  end

  test 'failed login with empty credentials' do
    # Arrange
    visit_sign_in_page

    # Act
    click_sign_in_button

    # Assert
    assert_signed_out
    assert_text 'Invalid username or password.'
  end

  test 'multiple failed login attempts' do
    # Arrange
    visit_sign_in_page

    # Act
    3.times do |_i|
      sign_in_with_wrong_password
      assert_signed_out
    end
    sign_in_with_test_user

    # Assert
    assert_signed_in
  end

  test 'username field can be case insensitive' do
    # Arrange
    visit_sign_in_page

    # Act
    fill_username 'TEST_USER'
    fill_password 'h2&BUa0qvxoqTM^K'
    click_sign_in_button

    # Act
    assert_signed_in
  end

  test 'username can have leading and trailing spaces' do
    # Arrange
    visit_sign_in_page

    # Act
    fill_username '  test_user  '
    fill_password 'h2&BUa0qvxoqTM^K'
    click_sign_in_button

    # Assert
    assert_signed_in
  end

  test 'sign in form submission with enter key' do
    # Arrange
    visit_sign_in_page

    # Act
    fill_username 'test_user'
    fill_password 'h2&BUa0qvxoqTM^K'
    find_field(SignInPageObject::PASSWORD_FIELD).native.send_keys(:return)

    # Assert
    assert_signed_in
  end

  test 'password field masks input' do
    # Arrange
    visit_sign_in_page

    # Act & Assert
    password_field = find_field(SignInPageObject::PASSWORD_FIELD)
    assert_equal 'password', password_field['type']
  end

  test 'fields have proper labels' do
    # Arrange
    visit_sign_in_page

    # Assert
    assert_selector 'label', text: 'Remember me'
  end

  test 'fields have proper placeholders' do
    # Arrange
    visit_sign_in_page

    # Assert
    assert_selector 'input[placeholder="Username"]'
    assert_selector 'input[placeholder="Password"]'
  end
end
