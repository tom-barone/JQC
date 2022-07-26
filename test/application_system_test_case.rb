# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def sign_in_test_user
    visit root_path
    fill_in 'Username', with: 'test'
    fill_in 'Password', with: 'test_password'
    click_on 'Sign in'
    assert_text 'New Application'
  end
end
