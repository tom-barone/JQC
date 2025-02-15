# frozen_string_literal: true

module SignInHelper
  def assert_sign_in_page
    assert_text 'Remember me'
    assert_field 'Username'
    assert_field 'Password'
    assert_button 'Sign in'
  end

  def sign_in_test_user
    visit root_path
    assert_text 'Remember me'
    fill_in 'Username', with: 'test'
    fill_in 'Password', with: 'test_password'
    click_on 'Sign in'
    assert_text 'Sign out'
  end

  def sign_out
    click_on 'Sign out'
    assert_sign_in_page
  end
end
