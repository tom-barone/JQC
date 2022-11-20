# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  #driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  fixtures :all
  Capybara.default_max_wait_time = 15 # Seconds

  # Don't put this in a setup {} block! Call manually in every single test
  def sign_in_test_user
    visit root_path
    assert_text('Remember me')
    fill_in 'Username', with: 'test'
    fill_in 'Password', with: 'test_password'
    click_on 'Sign in'
    assert_text('Sign out')
  end
end
