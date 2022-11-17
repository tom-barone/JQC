# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  setup { sign_in_test_user }

  test 'searching by application type' do
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
    april_application = applications(:application_Q1)
    april_application.update!(created_at: Date.new(2022, 4, 5))
    assert_no_text 'Q8001'

    # Date between
    fill_in 'start_date', with: '01/03/2022'
    fill_in 'end_date', with: '01/05/2022'
    click_on 'Search'
    assert_text 'Q8001'

    # Date == start
    fill_in 'start_date', with: '05/04/2022'
    fill_in 'end_date', with: '01/05/2022'
    click_on 'Search'
    assert_text 'Q8001'

    # Date == end
    fill_in 'start_date', with: '01/03/2022'
    fill_in 'end_date', with: '05/04/2022'
    click_on 'Search'
    assert_text 'Q8001'

    # Test that it goes away
    click_on 'clear-search'
    click_on 'Search'
    assert_text 'PC9001'
    assert_no_text 'Q8001'
  end

  test 'start and end date outliers do not show' do
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
    test_application = applications(:application_LG1)
    test_application.update!(description: 'Some description')

    select 'LG', from: 'type'
    fill_in 'start_date', with: '01/01/2022'
    fill_in 'end_date', with: '22/10/2022'
    fill_in 'search_text', with: 'Some description'

    # Post the form and check it searched properly
    click_on 'Search'
    within('.applications-table') do
      assert_text 'LG6001'
      assert_text 'Some description'
    end

    # Are they there?
    within('.search-form') do
      assert_text 'LG'

      # Need to use selectors for the inputs because they don't show as text to selenium
      assert_selector('option[value="LG"][selected="selected"]')
      assert_selector('#start_date[value="2022-01-01"]')
      assert_selector('#end_date[value="2022-10-22"]')
      assert_selector('#search_text[value="Some description"]')
    end

    click_on 'clear-search'
    click_on 'Search'

    # Are they gone?
    within('.search-form') do
      assert_no_selector('option[value="LG"][selected="selected"]')
      assert_no_selector('#start_date[value="2022-01-01"]')
      assert_no_selector('#end_date[value="2022-10-22"]')
      assert_no_selector('#search_text[value="Some description"]')
    end
  end

  # TODO: Add tests for search text
end
