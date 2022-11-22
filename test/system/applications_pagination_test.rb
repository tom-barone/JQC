# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  test 'The pagination of applications' do
    sign_in_test_user

    # Check the first page shows 1000 results
    5995.upto(5999) { |n| assert_text "PC#{n}" }
    5002.upto(5007) { |n| assert_text "PC#{n}" }
    assert_no_text 'PC5000'
    assert_no_text 'PC5001'

    assert_text '1012 results available'

    # Check clicking page 2 shows next 1000 results
    within('.pagination') { click_on '2' }

    assert_text 'PC5000'
    assert_text 'PC5001'
    assert_no_text 'PC5002'

  end
end
