# frozen_string_literal: true

require 'application_system_test_case'

class SignInTest < ApplicationSystemTestCase
  include SignInPageObject

  test 'successful login with valid credentials' do
    # Arrange
    user = create(:user)
    visit_sign_in_page

    # Act
    sign_in_with(user)

    # Assert
    assert_signed_in
  end

  test 'failed login with invalid username' do
    # Arrange
    user = create(:user)
    visit_sign_in_page

    # Act
    sign_in_with_fields("#{user.username}invalid", user.password)

    # Assert
    assert_signed_out
    assert_text 'Invalid username or password.'
  end

  test 'failed login with invalid password' do
    # Arrange
    user = create(:user)
    visit_sign_in_page

    # Act
    sign_in_with_fields(user.username, "#{user.password}invalid")

    # Assert
    assert_signed_out
    assert_text 'Invalid username or password.'
  end

  test 'failed login with empty credentials' do
    # Arrange
    create(:user)
    visit_sign_in_page

    # Act
    click_sign_in_button

    # Assert
    assert_signed_out
    assert_text 'Invalid username or password.'
  end

  test 'multiple failed login attempts' do
    # Arrange
    user = create(:user)
    visit_sign_in_page

    # Act
    3.times do |_i|
      sign_in_with_fields("#{user.username}invalid", "#{user.password}invalid")

      assert_signed_out
    end
    sign_in_with(user)

    # Assert
    assert_signed_in
  end

  test 'username field can be case insensitive' do
    # Arrange
    user = create(:user, username: 'test_user')
    visit_sign_in_page

    # Act
    sign_in_with_fields('TEST_USER', user.password)

    # Act
    assert_signed_in
  end

  test 'username can have leading and trailing spaces' do
    # Arrange
    user = create(:user, username: 'test_user')
    visit_sign_in_page

    # Act
    sign_in_with_fields('  test_user  ', user.password)

    # Assert
    assert_signed_in
  end

  test 'sign in form submission with enter key' do
    # Arrange
    user = create(:user)
    visit_sign_in_page

    # Act
    fill_username user.username
    fill_password user.password
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
