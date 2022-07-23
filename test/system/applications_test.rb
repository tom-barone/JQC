# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    sign_in_test_user
  end

  test 'The main application page' do
    # Test both urls "/" and "/applications" show the applications table
    [root_path, applications_url].each do |url|
      visit url
      assert_text 'Reference Number'

      # Check all the PCs are there
      1.upto(5) { |n| assert_text "PC#{n}" }

      # Check all the LGs are there
      1.upto(5) { |n| assert_text "LG#{n}" }
    end

    # Test that all column headers are shown
    [
      'Reference Number',
      'Location',
      'Suburb',
      'Description',
      'Contact',
      'Owner',
      'Applicant',
      'Council',
      'Date Created',
      'DA No.'
    ].each { |header| assert_text header }

    # Check all PC details are shown
    applications.each do |a|
      next unless a.application_type == 'PC'
      assert_text a.reference_number
      assert_text "#{a.lot_number} #{a.street_number} #{a.street_name}"
      assert_text a.suburb.display_name
      assert_text a.description
      assert_text a.client.client_name
      assert_text a.owner.client_name
      assert_text a.applicant.client_name
      assert_text a.council.name
      assert_text a.created_at
      assert_text a.development_application_number
    end

    # Check that location names display properly

    # Test searching by application type
    select 'LG', from: 'select_type'
    click_on 'Search'
    1.upto(5) { |n| assert_no_text "PC#{n}", wait: 10 }
    1.upto(5) { |n| assert_text "LG#{n}" }
  end
end
