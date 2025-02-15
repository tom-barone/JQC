# frozen_string_literal: true

require 'application_system_test_case'

class PaginationTest < ApplicationSystemTestCase
  test 'Pagination of the main application table works as expected' do
    sign_in_test_user

    assert_text 'SC8000'
    assert_text 'SC7500'

    click_link_or_button '2' # Go to the second page

    assert_text 'SC7000'
    assert_text 'SC6500'

    click_link_or_button '4' # Go back to the last page

    assert_text 'SC5000'
  end
end
