# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1800, 1000]

  # driven_by :selenium, using: :chrome, screen_size: [1800, 1000]

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

  def assert_on_homepage
    # Can see the "New Application" button
    assert_text('New Application')
  end

  def edit_application(reference_number)
    assert_text reference_number
    find("#row-#{reference_number}").click
    sleep(4)
    assert_text 'Administration'
  end

  # Use like
  #   assert_field_has_value('#application_reference_number', 'Q8003')
  def assert_field_has_value(id, str)
    assert_equal(find(id)[:value], str)
  end

  # Use like
  #   assert_datalist_option_exists('clients', 'applicant1 from firm1')
  def assert_datalist_option_exists(id, value)
    assert_selector("##{id} option[value='#{value}']", visible: :all)
  end
end
