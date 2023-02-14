# frozen_string_literal: true

require 'application_system_test_case'

class ClientEditTest < ApplicationSystemTestCase
  def fill_everything_in
    self.client_name = 'A new owner name'
    self.client_type = 'Individual'
    self.client_bad_payer = true
    self.client_first_name = 'Jeff'
    self.client_surname = 'Bones'
    self.client_initials = 'JB'
    self.client_title = 'Dr.'
    self.client_salutation = 'Mr.'
    self.client_company_name = 'A Place Inc.'
    self.client_australian_business_number = '12345'
    self.client_state = 'SA'
    self.client_phone = '8883994'
    self.client_fax = '23374'
    self.client_mobile_number = '23490002'
    self.client_email = 'jeff@email.com'
    self.client_street = 'Some street'
    self.client_suburb = 'SUBURB1, SA XXXX'
    self.client_postal_address = 'Some postal address'
    self.client_postal_suburb =  'SUBURB2, SA XXXX'
    self.client_notes = 'Special notes'
  end

  def assert_everything_is_filled_in
    assert_client_name('A new owner name')
    assert_client_type('Individual')
    assert_client_bad_payer(true)
    assert_client_first_name('Jeff')
    assert_client_surname('Bones')
    assert_client_initials('JB')
    assert_client_title('Dr.')
    assert_client_salutation('Mr.')
    assert_client_company_name('A Place Inc.')
    assert_client_australian_business_number('12345')
    assert_client_state('SA')
    assert_client_phone('8883994')
    assert_client_fax('23374')
    assert_client_mobile_number('23490002')
    assert_client_email('jeff@email.com')
    assert_client_street('Some street')
    assert_client_suburb('SUBURB1, SA XXXX')
    assert_client_postal_address('Some postal address')
    assert_client_postal_suburb('SUBURB2, SA XXXX')
    assert_client_notes('Special notes')
  end

  def fill_everything_in_with_other_stuff
    self.client_name = 'Someone else'
    self.client_type = 'Business'
    self.client_bad_payer = false
    self.client_first_name = 'Other'
    self.client_surname = 'Lastname'
    self.client_initials = 'OL'
    self.client_title = 'Phd.'
    self.client_salutation = 'Ms.'
    self.client_company_name = 'Other company'
    self.client_australian_business_number = '5432'
    self.client_state = 'WA'
    self.client_phone = '82823'
    self.client_fax = '99904'
    self.client_mobile_number = '128843'
    self.client_email = 'Other@email.com'
    self.client_street = 'Another street'
    self.client_suburb = 'SUBURB2, SA XXXX'
    self.client_postal_address = 'Other postal address'
    self.client_postal_suburb =  'SUBURB1, SA XXXX'
    self.client_notes = 'Not very special notes'
  end

  def assert_everything_has_changed
    assert_no_client_name('A new owner name')
    assert_no_client_type('Individual')
    assert_no_client_bad_payer(true)
    assert_no_client_first_name('Jeff')
    assert_no_client_surname('Bones')
    assert_no_client_initials('JB')
    assert_no_client_title('Dr.')
    assert_no_client_salutation('Mr.')
    assert_no_client_company_name('A Place Inc.')
    assert_no_client_australian_business_number('12345')
    assert_no_client_state('SA')
    assert_no_client_phone('8883994')
    assert_no_client_fax('23374')
    assert_no_client_mobile_number('23490002')
    assert_no_client_email('jeff@email.com')
    assert_no_client_street('Some street')
    assert_no_client_suburb('SUBURB1, SA XXXX')
    assert_no_client_postal_address('Some postal address')
    assert_no_client_postal_suburb('SUBURB2, SA XXXX')
    assert_no_client_notes('Special notes')
  end

  test 'presence of the edit buttons' do
    sign_in_test_user

    edit_application 'PC9001'
    assert_on_application_edit_page
    assert_edit_applicant_button
    assert_edit_owner_button
    assert_edit_contact_button
    exit_application
    assert_on_homepage

    # Test with an application with no owner
    app = applications(:application_PC1)
    app.update!(owner: nil)
    sleep(1)
    edit_application 'PC9001'
    assert_on_application_edit_page
    assert_edit_applicant_button
    assert_no_edit_owner_button
    assert_edit_contact_button
    exit_application
    assert_on_homepage

    # Test with an application with no applicant, owner, contact
    app.update!(applicant: nil)
    app.update!(contact: nil)
    sleep(1)
    edit_application 'PC9001'
    assert_on_application_edit_page
    assert_no_edit_applicant_button
    assert_no_edit_owner_button
    assert_no_edit_contact_button
  end

  test 'visiting and saving the client details' do
    sign_in_test_user

    edit_application 'PC9001'
    assert_on_application_edit_page
    edit_owner
    fill_everything_in
    assert_everything_is_filled_in
    fill_everything_in_with_other_stuff
    assert_everything_has_changed
    exit_client

    # Check nothing has saved
    assert_on_application_edit_page
    edit_owner
    assert_everything_has_changed
    fill_everything_in
    assert_everything_is_filled_in
    save_client

    # Check everything saved
    assert_on_application_edit_page
    edit_owner
    assert_everything_is_filled_in
    exit_client

    # Changing the client name updates is visible across all related applications
    exit_application
    assert_on_homepage
    assert_in_homepage_table 'A new owner name', count: 2
  end

  test 'Each of the edit buttons work' do
    sign_in_test_user

    edit_application 'PC9001'
    assert_on_application_edit_page

    edit_applicant
    assert_client_name('applicant1 from firm1')
    exit_client
    assert_on_application_edit_page

    edit_owner
    assert_client_name('owner1 lastname1')
    exit_client
    assert_on_application_edit_page

    edit_contact
    assert_client_name('contact1 of group1')
    exit_client
    assert_on_application_edit_page
  end
end
