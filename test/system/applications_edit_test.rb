# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
  test 'selecting and adding a new council' do
    sign_in_test_user

    # Check correct fields and datalist options
    edit_application 'PC9001'
    assert_application_council 'the council1 of place1'
    assert_can_select 'the council1 of place1', from: 'councils'
    assert_can_select 'the council2 of place2', from: 'councils'

    # Choose a different council
    self.application_council = 'the council2 of place2'
    save_application

    # Check visible in the application table
    assert_in_homepage_table 'the council2 of place2'

    # Add a new council
    edit_application 'PC9001'
    assert_application_council 'the council2 of place2'
    self.application_new_council = 'a completely new council'
    save_application

    # Check new council visible in the application table
    assert_in_homepage_table 'a completely new council'

    # Check they are now selectable in the dropdown for councils
    edit_application 'PC9001'
    assert_can_select 'a completely new council', from: 'councils'

    # Check remove
    self.application_new_council = ''
    save_application
    assert_on_homepage
    assert_not_in_homepage_table 'a completely new council'
  end

  test 'selecting and adding new clients' do
    sign_in_test_user

    # Check correct fields and datalist options
    edit_application 'PC9001'
    assert_application_applicant 'applicant1 from firm1'
    assert_application_owner 'owner1 lastname1'
    assert_application_contact 'contact1 of group1'

    assert_can_select 'contact1 of group1', from: 'clients'
    assert_can_select 'contact2 of group2', from: 'clients'
    assert_can_select 'owner1 lastname1', from: 'clients'
    assert_can_select 'owner2 lastname2', from: 'clients'
    assert_can_select 'applicant1 from firm1', from: 'clients'
    assert_can_select 'applicant2 from firm2', from: 'clients'

    # Choose new client settings
    self.application_applicant = 'applicant2 from firm2'
    self.application_owner = 'owner2 lastname2'
    self.application_contact = 'contact2 of group2'
    save_application
    assert_on_homepage

    # Check they're visible in the table
    assert_in_homepage_table 'applicant2 from firm2'
    assert_in_homepage_table 'owner2 lastname2'
    assert_in_homepage_table 'contact2 of group2'

    # Add completely new clients
    edit_application 'PC9001'
    assert_application_applicant 'applicant2 from firm2'
    assert_application_owner 'owner2 lastname2'
    assert_application_contact 'contact2 of group2'

    self.application_new_applicant = 'newClient1'
    self.application_new_owner = 'newClient2'
    self.application_new_contact = 'newClient1'
    save_application
    assert_on_homepage

    # Check they show up in the applications table
    assert_in_homepage_table 'newClient1', count: 2
    assert_in_homepage_table 'newClient2', count: 1

    # Check they are now selectable in the dropdown for clients
    edit_application 'PC9001'
    assert_can_select 'newClient1', from: 'clients'
    assert_can_select 'newClient2', from: 'clients'

    # Check remove
    self.application_new_applicant = ''
    self.application_new_owner = ''
    self.application_new_contact = ''
    save_application
    assert_on_homepage
    assert_not_in_homepage_table 'newClient1'
    assert_not_in_homepage_table 'newClient2'
  end

  test 'converting to a new application type' do
    sign_in_test_user

    edit_application 'PC9002'
    assert_application_reference_number 'PC9002'

    self.application_description = "I'm converted!"
    self.application_type = 'Q'
    assert_application_reference_number 'Q8003'
    assert_application_converted_to_from 'Auto generated'
    self.application_administration_notes = 'The admin has been too!'
    save_application
    assert_on_homepage

    self.homepage_search_type = 'Q'
    homepage_search
    assert_in_homepage_table 'Q8003'
    assert_in_homepage_table 'Q8002'
    assert_in_homepage_table 'Q8001'
    edit_application 'Q8003'

    assert_application_converted_to_from 'PC9002'
    assert_application_description "I'm converted!"
    assert_application_administration_notes 'The admin has been too!'

    save_application

    self.homepage_search_type = 'PC'
    homepage_search
    assert_in_homepage_table 'PC9002'
    edit_application 'PC9002'
    assert_application_converted_to_from 'Q8003'
    assert_application_description "I'm converted!"
    assert_application_administration_notes 'The admin has been too!'
    save_application

    edit_application 'PC9001'
    self.application_type = 'Q'
    assert_application_reference_number 'Q8004'
    assert_application_converted_to_from 'Auto generated'
  end

  test 'converting to a different application type does not break ' do
    sign_in_test_user

    edit_application 'PC9001'
    self.application_type = 'LG'
    assert_application_reference_number 'LG6003'
    self.application_type = 'RC'
    assert_application_reference_number 'RC2091'
    self.application_type = 'LG'
    assert_application_reference_number 'LG6003'
    save_application

    edit_application 'PC5999'
    self.application_type = 'RC'
    assert_application_reference_number 'RC2091'
    self.application_type = 'LG'
    assert_application_reference_number 'LG6004'
  end

  test 'saving deleting and exiting works as expected' do
    # TODO: Add a god test that checks every single field saves properly
    sign_in_test_user

    edit_application 'PC9001'
    assert_application_description 'Some demolition happened here'
    self.application_description = 'A changed description'
    save_application
    assert_in_homepage_table 'A changed description'

    edit_application 'PC9001'
    self.application_description = 'An unsaved description'
    exit_application
    assert_on_homepage
    assert_in_homepage_table 'A changed description'
    assert_not_in_homepage_table 'An unsaved description'

    edit_application 'PC9001'
    delete_application
    assert_on_homepage
    assert_not_in_homepage_table 'PC9001'
    assert_not_in_homepage_table 'A changed description'
  end

  test 'client side validiation of form fields' do
    sign_in_test_user

    edit_application 'PC9001'
    self.application_number_of_storeys = '999999999'
    save_application

    assert_validation_message(
      'application_number_of_storeys',
      shows: 'Value must be less than or equal to 99.'
    )

    # The button shouldn't be stuck on saving
    assert_no_text 'Saving...'
    assert_text 'Save'

    # Removing problem allows save
    self.application_number_of_storeys = '1'
    save_application
    assert_on_homepage

    # Can exit and it won't complain
    edit_application 'PC9001'
    assert_application_number_of_storeys '1'
    self.application_number_of_storeys = '999999999'
    self.application_description = 'Something' # fixes click issue
    exit_application
    assert_on_homepage

    # Can delete and it won't complain
    edit_application 'PC9001'
    assert_application_number_of_storeys '1'
    self.application_number_of_storeys = '999999999'
    self.application_description = 'Something else' # fixes click issue
    delete_application
    assert_on_homepage
    assert_not_in_homepage_table 'PC9001'
  end

  # Invoice table test
  # empty application with no invoices still shows $0.00
  # Add invoice button shows all fields and delete button
  # Add Date,Stage,KD Fee (updates total and gst), Ins Levy (updates total & gst),
  #   Admin (updates total), Dac (updates total), lodgement (updates total), invoice number, paid,
  #   fully invoiced, save
  # Check all fields saved properly, correct totals and gst are shown
  # Add new invoice field, shows more fields and delete button
  # Add more data and save, check that there are still 2
  #
  # Update 2nd with bad data, check doesn't work
  # Update 2nd Kd fee, ins levy, admin, dac, lodgment -> check totals & gst
  # Delete 2nd -> check totals and gst
  # Click exit, check changes aren't saved
  #
  # Check delete still updates the totals
end
