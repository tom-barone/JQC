# frozen_string_literal: true

require 'application_system_test_case'
require 'helpers/sign_in_helper'

class PaginationTest < ApplicationSystemTestCase
  include SignInHelper

  test 'Pagination of the main application table works as expected' do
    sign_in_test_user

    assert_text 'LG8000'
    assert_text 'LG7500'

    click_link_or_button '2' # Go to the second page

    assert_text 'LG7000'
    assert_text 'LG6500'

    click_link_or_button '4' # Go back to the last page

    assert_text 'LG5000'
    sleep 3
  end
end
