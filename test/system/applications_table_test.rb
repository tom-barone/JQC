# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTableTest < ApplicationSystemTestCase
  test 'the application table shows correct headings and values' do
    sign_in_test_user

    # Column headers
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

    # Request Support button shows my email
    click_on 'Request Support'
    assert_text 'mail@tombarone.net'
    click_on 'Request Support'
    assert_no_text 'mail@tombarone.net'

    # Table values
    assert_text 'PC9001'
    assert_text '3 12 Romito street'
    assert_text 'Some demolition happened here'
    assert_text 'contact1 of group1'
    assert_text 'owner1 lastname1'
    assert_text 'applicant1 from firm1'
    assert_text 'the council1 of place1'
    assert_text '10 Jul 2022'
    assert_text '123487423'
    assert_text 'Edit'
  end
end
