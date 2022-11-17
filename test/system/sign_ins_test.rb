# frozen_string_literal: true

require 'application_system_test_case'

class SignInsTest < ApplicationSystemTestCase
  test 'Before signing in, all URLs redirect to the login page' do
    visit root_path
    assert_text 'Please sign in'
    assert_no_text 'Please sign in before continuing.'

    visit applications_url
    assert_text 'Please sign in'
    assert_text 'Please sign in before continuing.'

    visit "#{applications_url}?type=&start_date=&end_date=&search_text=&commit=Search"
    assert_text 'Please sign in'
    assert_text 'Please sign in before continuing.'

    visit clients_url
    assert_text 'Please sign in'
    assert_text 'Please sign in before continuing.'
  end

  test 'Logging into the system with incorrect credentials fails' do
    visit root_path

    fill_in 'Username', with: 'test'
    fill_in 'Password', with: 'wrong_password'
    click_on 'Sign in'

    assert_no_text 'New Application'
    assert_text 'Please sign in'
    assert_text 'Invalid username or password.'

  end

  test 'Signing out takes you to the login page' do
    sign_in_test_user
    click_on 'Sign out'

    assert_no_text 'New Application'
    assert_text 'Please sign in'
    assert_text 'Signed out successfully.'
  end
end
