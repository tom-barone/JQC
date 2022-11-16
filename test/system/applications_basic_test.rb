# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  test 'The main application page' do
    sign_in_test_user

    yesterday = (Time.zone.now - 1.day).strftime('%Y-%m-%d')
    today = Time.zone.now.strftime('%Y-%m-%d')
    tomorrow = (Time.zone.now + 1.day).strftime('%Y-%m-%d')

    # Check the search datepickers are setup correctly so you can't search in the future
    # NOTE: Accept a range of 3 days, because it's too hard to try matching timezones between 
    # the headless browser and ruby, and could even fail anyway if the browser loads 
    # at 11:59:59pm and this test runs at 12:00:01am
    assert_any_of_selectors(
      "#start-datepicker[max=\"#{yesterday}\"]",
      "#start-datepicker[max=\"#{today}\"]",
      "#start-datepicker[max=\"#{tomorrow}\"]"
    )
    assert_any_of_selectors(
      "#end-datepicker[max=\"#{yesterday}\"]",
      "#end-datepicker[max=\"#{today}\"]",
      "#end-datepicker[max=\"#{tomorrow}\"]"
    )

    #created_pcs = create_list(:application, 5)
    ##created_lgs =
    ##create_list(:application, 5) do |application, i|
    ##application.reference_number = "LG#{i}"
    ##end

    #sign_in_test_user

    ## Test both urls "/" and "/applications" show the applications table
    #[root_path, applications_url].each do |url|
    #visit url
    #assert_text 'Reference Number'

    ## Check all the PC & LG reference numbers are there
    #created_pcs.each do |application|
    #assert_text application.reference_number
    #end
    ##created_lgs.each do |application|
    ##assert_text application.reference_number
    ##end
    #end

    # Test that all column headers are shown
    #[
    #'Reference Number',
    #'Location',
    #'Suburb',
    #'Description',
    #'Contact',
    #'Owner',
    #'Applicant',
    #'Council',
    #'Date Created',
    #'DA No.'
    #].each { |header| assert_text header }

    ## Check all PC details are shown
    #applications.each do |a|
    #next unless a.application_type == 'PC'
    #assert_text a.reference_number
    #assert_text "#{a.lot_number} #{a.street_number} #{a.street_name}"
    #assert_text a.suburb.display_name
    #assert_text a.description
    #assert_text a.client.client_name
    #assert_text a.owner.client_name
    #assert_text a.applicant.client_name
    #assert_text a.council.name
    #assert_text a.created_at
    #assert_text a.development_application_number
    #end

    ## Check that location names display properly

    ## Test searching by application type
    #select 'LG', from: 'select_type'
    #click_on 'Search'
    #1.upto(5) { |n| assert_no_text "PC#{n}", wait: 10 }
    #1.upto(5) { |n| assert_text "LG#{n}" }

    ## Check the Request Support button shows my email
    #click_on 'Request Support'
    #assert_text 'mail@tombarone.net'
    #click_on 'Request Support'
    #assert_no_text 'mail@tombarone.net'
  end
end
