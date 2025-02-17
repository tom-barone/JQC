# frozen_string_literal: true

require 'application_system_test_case'

class SignInsTest < ApplicationSystemTestCase
  test 'Unauthenticated users are redirected to the sign in page' do
    visit root_path
    assert_sign_in_page

    sign_in_test_user
    sign_out

    visit new_application_path
    assert_sign_in_page

    visit applications_path
    assert_sign_in_page
  end
end
