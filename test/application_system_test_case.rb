# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def assert_sign_in_page
    assert_text 'Remember me'
    assert_field 'Username'
    assert_field 'Password'
    assert_button 'Sign in'
  end

  def sign_in_with(username, password)
    visit root_path
    assert_text 'Remember me'
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_on 'Sign in'
    assert_text 'Sign out'
  end

  def sign_in_test_user
    sign_in_with 'test_user', 'h2&BUa0qvxoqTM^K'
  end

  def sign_out
    click_on 'Sign out'
    assert_sign_in_page
  end
end
