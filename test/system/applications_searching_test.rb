# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  test 'searching by application type' do
    sign_in_test_user
    assert_no_text 'RC5001'
    assert_no_text 'RC5002'
    select 'RC', from: 'type'
    click_on 'Search'
    assert_text 'RC5001'
    assert_text 'RC5002'

    # Clear the field and search again
    select 'Select Type:', from: 'type'
    click_on 'Search'
    assert_no_text 'RC5001'
    assert_no_text 'RC5002'
  end

  test 'searching by start & end date' do
    sign_in_test_user
    april_application = applications(:application_Q1)
    april_application.update!(created_at: Date.new(2022, 4, 5))
    assert_no_text 'Q8001'

    def clear
      click_on 'clear-search'
      assert_no_text 'PC9001'
      click_on 'Search'
      assert_text 'PC9001'
    end

    # Date between
    fill_in 'start_date', with: '01/03/2022'
    fill_in 'end_date', with: '01/05/2022'
    click_on 'Search'
    assert_text 'Q8001'

    clear

    # Date == start
    fill_in 'start_date', with: '05/04/2022'
    fill_in 'end_date', with: '01/05/2022'
    click_on 'Search'
    assert_text 'Q8001'

    clear

    # Date == end
    fill_in 'start_date', with: '01/03/2022'
    fill_in 'end_date', with: '05/04/2022'
    click_on 'Search'
    assert_text 'Q8001'

    clear

    # Test that it goes away
    assert_no_text 'Q8001'
  end

  test 'start and end date outliers do not show' do
    sign_in_test_user
    assert_text 'PC9001'
    assert_text 'PC9002'

    pc1 = applications(:application_PC1)
    pc2 = applications(:application_PC2)
    pc1.update!(created_at: Date.new(1855, 4, 5)) # too old
    pc2.update!(created_at: Date.new(2500, 4, 5)) # too new

    # refresh page and check they are not there anymore
    click_on 'clear-search'
    click_on 'Search'
    assert_no_text 'PC9001'
    assert_no_text 'PC9002'
  end

  test 'clearing search parameters' do
    sign_in_test_user
    test_application = applications(:application_LG1)
    test_application.update!(description: 'Something or rather')

    select 'LG', from: 'type'
    fill_in 'start_date', with: '01/01/2022'
    fill_in 'end_date', with: '22/10/2022'
    fill_in 'search_text', with: '6001'

    # Post the form and check it searched properly
    click_on 'Search'
    within('.applications-table') do
      assert_text 'LG6001'
      assert_text 'Something or rather'
    end

    # Are they there?
    within('.search-form') do
      assert_text 'LG'
      # Need to use selectors for the inputs because they don't show as text to selenium
      assert_selector('option[value="LG"][selected="selected"]')
      assert_selector('#start_date[value="2022-01-01"]')
      assert_selector('#end_date[value="2022-10-22"]')
      assert_selector('#search_text[value="6001"]')
    end

    click_on 'clear-search'
    click_on 'Search'

    # Are they gone?
    within('.search-form') do
      assert_no_selector('option[value="LG"][selected="selected"]')
      assert_no_selector('#start_date[value="2022-01-01"]')
      assert_no_selector('#end_date[value="2022-10-22"]')
      assert_no_selector('#search_text[value="6001"]')
    end
  end

  # TODO: Add tests for search text
  # TODO: Fix bug that occurs when trying to search by description
end
