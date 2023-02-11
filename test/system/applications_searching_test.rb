# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsSearchingTest < ApplicationSystemTestCase
  def text_search_and_assert(str, asserting, assert_str)
    self.homepage_search_text = str
    homepage_search
    if asserting == 'assert'
      assert_text assert_str
    else
      assert_no_text assert_str
    end
  end

  test 'searching by application type' do
    sign_in_test_user
    assert_not_in_homepage_table 'RC5001'
    assert_not_in_homepage_table 'RC5002'
    self.homepage_search_type = 'RC'
    homepage_search
    assert_in_homepage_table 'RC5001'
    assert_in_homepage_table 'RC5002'

    # Clear the field and search again
    self.homepage_search_type = 'Select Type:'
    homepage_search
    assert_not_in_homepage_table 'RC5001'
    assert_not_in_homepage_table 'RC5002'
  end

  test 'searching by start & end date' do
    sign_in_test_user

    # Check the search datepickers are setup correctly so you can't search in the future
    # NOTE: Accept a range of 3 days, because it's too hard to try matching timezones between
    # the headless browser and ruby, and could even fail anyway if the browser loads
    # at 11:59:59pm and this test runs at 12:00:01am
    yesterday = (Time.zone.now - 1.day).strftime('%Y-%m-%d')
    today = Time.zone.now.strftime('%Y-%m-%d')
    tomorrow = (Time.zone.now + 1.day).strftime('%Y-%m-%d')
    assert_any_of_selectors(
      "#start_date[max=\"#{yesterday}\"]",
      "#start_date[max=\"#{today}\"]",
      "#start_date[max=\"#{tomorrow}\"]"
    )
    assert_any_of_selectors(
      "#end_date[max=\"#{yesterday}\"]",
      "#end_date[max=\"#{today}\"]",
      "#end_date[max=\"#{tomorrow}\"]"
    )

    april_application = applications(:application_Q1)
    april_application.update!(created_at: Date.new(2022, 4, 5))
    assert_not_in_homepage_table 'Q8001'

    def clear
      homepage_search_clear
      assert_not_in_homepage_table 'PC9001'
      homepage_search
      assert_in_homepage_table 'PC9001'
    end

    # Date between
    self.homepage_search_start_date = Date.new(2022, 3, 1)
    self.homepage_search_end_date = Date.new(2022, 5, 1)
    homepage_search
    assert_in_homepage_table 'Q8001'

    clear

    # Date == start
    self.homepage_search_start_date = Date.new(2022, 4, 5)
    self.homepage_search_end_date = Date.new(2022, 5, 1)
    homepage_search
    assert_in_homepage_table 'Q8001'

    clear

    # Date == end
    self.homepage_search_start_date = Date.new(2022, 3, 1)
    self.homepage_search_end_date = Date.new(2022, 4, 5)
    homepage_search
    assert_in_homepage_table 'Q8001'

    clear

    # Test that it goes away
    assert_not_in_homepage_table 'Q8001'
  end

  test 'start and end date outliers do not show' do
    sign_in_test_user
    assert_in_homepage_table 'PC9001'

    pc1 = applications(:application_PC1)
    pc1.update!(created_at: Date.new(1855, 4, 5)) # too old

    # refresh page and check they are not there anymore
    homepage_search_clear
    homepage_search
    assert_not_in_homepage_table 'PC9001'
  end

  test 'clearing search parameters' do
    sign_in_test_user
    test_application = applications(:application_LG1)
    test_application.update!(description: 'Something or rather')

    select 'LG', from: 'type'
    self.homepage_search_start_date = Date.new(2022, 1, 1)
    self.homepage_search_end_date = Date.new(2022, 10, 22)
    self.homepage_search_text = 'something rather'

    # Post the form and check it searched properly
    homepage_search
    assert_in_homepage_table 'LG6001'
    assert_in_homepage_table 'Something or rather'

    # Are they there?
    assert_homepage_search_type('LG')
    assert_homepage_search_start_date('2022-01-01')
    assert_homepage_search_end_date('2022-10-22')
    assert_homepage_search_text('something rather')

    homepage_search_clear
    homepage_search

    # Are they gone?
    assert_no_homepage_search_type('LG')
    assert_no_homepage_search_start_date('2022-01-01')
    assert_no_homepage_search_end_date('2022-10-22')
    assert_no_homepage_search_text('something rather')
  end

  test 'searching by text' do
    sign_in_test_user

    # Reference numbers
    text_search_and_assert('LG6', 'assert', 'LG6001')
    text_search_and_assert('LG7', 'assert_no', 'LG6001')
    self.homepage_search_text = 'PC591'
    homepage_search
    5910.upto(5919) { |n| assert_in_homepage_table "PC#{n}" }
    assert_not_in_homepage_table 'PC5909'
    assert_not_in_homepage_table 'PC5920'

    # Hitting the enter key also works
    self.homepage_search_text = 'SC4'
    find('#search_text').send_keys(:enter)
    assert_in_homepage_table('SC4001')
    assert_in_homepage_table('SC4002')

    # Location
    app = applications(:application_PC5900)
    app.update!(street_name: 'Easy street', street_number: 1234)
    text_search_and_assert('Easy', 'assert', 'PC5900')
    text_search_and_assert('ztreet', 'assert_no', 'PC5900')
    text_search_and_assert('1234', 'assert', 'PC5900')
    text_search_and_assert('234', 'assert_no', 'PC5900')

    # DA number
    app = applications(:application_PC5901)
    app.update!(development_application_number: 'DA5555')
    text_search_and_assert('DA5555', 'assert', 'PC5901')

    # Description
    app = applications(:application_PC5902)
    app.update!(description: 'Single word search')
    text_search_and_assert('single', 'assert', 'PC5902')
    app = applications(:application_PC5903)
    app.update!(description: 'Double word search')
    text_search_and_assert('Double word', 'assert', 'PC5903')

    # Suburb
    app = applications(:application_PC5904)
    suburb2 = suburbs(:suburb2)
    app.update!(suburb: suburb2)
    text_search_and_assert('SUBURB2', 'assert', 'PC5904')
    assert_in_homepage_table('SUBURB2, SA XXXX')
    assert_not_in_homepage_table('SUBURB1')

    # Council
    app = applications(:application_PC5905)
    council2 = councils(:council2)
    app.update!(council: council2)
    text_search_and_assert('council2', 'assert', 'PC5905')
    text_search_and_assert('councilzzzz', 'assert_no', 'PC5905')
    text_search_and_assert('council2 of place2', 'assert', 'PC5905')
    assert_in_homepage_table('council2')
    assert_not_in_homepage_table('council1')

    # Contact
    app = applications(:application_PC5906)
    contact2 = clients(:contact2)
    app.update!(contact: contact2)
    text_search_and_assert('contact2', 'assert', 'PC5906')
    text_search_and_assert('contactzzzz', 'assert_no', 'PC5906')
    text_search_and_assert('contact2 of group2', 'assert', 'PC5906')
    assert_in_homepage_table('contact2')
    assert_not_in_homepage_table('contact1')

    # Owner
    app = applications(:application_PC5907)
    owner2 = clients(:owner2)
    app.update!(owner: owner2)
    text_search_and_assert('owner2', 'assert', 'PC5907')
    text_search_and_assert('ownerzzzz', 'assert_no', 'PC5907')
    text_search_and_assert('owner2 lastname', 'assert', 'PC5907')
    assert_in_homepage_table('owner2')
    assert_not_in_homepage_table('owner1')

    # Applicant
    app = applications(:application_PC5908)
    applicant2 = clients(:applicant2)
    app.update!(applicant: applicant2)
    text_search_and_assert('applicant2', 'assert', 'PC5908')
    text_search_and_assert('applicantzzzz', 'assert_no', 'PC5908')
    text_search_and_assert('applicant2 from firm2', 'assert', 'PC5908')
    assert_in_homepage_table('applicant2')
    assert_not_in_homepage_table('applicant1')
  end

  test 'searching text with naughty inputs like commas, semicolons, quotes and percent signs' do
    sign_in_test_user

    app = applications(:application_PC1)
    app.update!(description: "Mr O'Neil aa\"sdc %sd% ;DROP ssad ^#d ''\"cdv%;Dcs*20")

    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert("Mr O'Neil", 'assert', 'PC9001')
    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert('aa"sdc', 'assert', 'PC9001')
    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert('%sd%', 'assert', 'PC9001')
    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert(';DROP', 'assert', 'PC9001')
    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert('ssad', 'assert', 'PC9001')
    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert('^#d', 'assert', 'PC9001')
    text_search_and_assert('reset', 'assert_no', 'PC9001')
    text_search_and_assert("''\"cdv%;Dcs*20", 'assert', 'PC9001')
  end
end
