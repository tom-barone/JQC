# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationCreateAndEditTest < ApplicationSystemTestCase
  def fill_everything_in
    # Add one of everything
    self.application_new_type = 'PC'
    self.application_council = 'the council1 of place1'
    self.application_development_application_number = 'da1234'
    self.application_applicant = 'applicant1 from firm1'
    self.application_owner = 'owner1 lastname1'
    self.application_contact = 'contact1 of group1'
    self.application_description = 'we did something'
    self.application_administration_notes = 'admin notes about stuff'
    self.application_number_of_storeys = '3'
    self.application_construction_value = '123500.0'
    self.application_lot_number = '4'
    self.application_street_number = '88'
    self.application_street_name = 'Romito Street'
    self.application_suburb = 'SUBURB1, SA XXXX'
    self.application_fee_amount = '3453.0'
    self.application_electronic_lodgement = true
    self.application_engagement_form = true
    self.application_job_type_administration = 'Residential'
    self.application_quote_accepted_date = Date.new(2022, 7, 3)
    self.application_applicant_email = 'applicant@email.com'
    self.application_risk_rating = 'High'
    application_add_additional_information(Date.new(2022, 7, 1), 'Extra added info')
    application_add_additional_information(Date.new(2023, 7, 1), 'Even more info')
    application_add_uploaded(Date.new(2022, 10, 4), 'COO')
    application_add_uploaded(Date.new(2023, 10, 4), 'Variation')
    self.application_building_surveyor = 'Vic'
    self.application_assessment_assigned = Date.new(2022, 7, 5)
    self.application_structural_engineer = 'External'
    self.application_external_engineer_date = Date.new(2022, 7, 6)
    application_add_rfi(Date.new(2022, 7, 7))
    application_add_rfi(Date.new(2023, 7, 7))
    application_add_stage(Date.new(2022, 7, 8), 'Substructure')
    application_add_stage(Date.new(2023, 7, 8), 'Superstructure')
    self.application_consultancies_review_inspection = Date.new(2021, 3, 29)
    self.application_consultancies_report_sent = Date.new(2021, 3, 28)
    self.application_consent_issued = Date.new(2022, 7, 9)
    self.application_variation_issued = Date.new(2022, 7, 10)
    self.application_coo_issued = Date.new(2022, 7, 11)
    self.application_engineer_certificate_received = Date.new(2022, 7, 12)
    self.application_certification_notes = 'certification went well'
    self.application_invoice_to = 'this person'
    self.application_care_of = 'that guy'
    self.application_invoice_email = 'guyperson@email.com'
    self.application_attention = 'the bosses'
    self.application_purchase_order_number = '5554'
    self.application_invoice_debtor_notes = 'debtor notes this that other'
    application_add_invoice(Date.new(2022, 11, 13), 'stage1', '12', '', '55', true)
    application_add_invoice(Date.new(2023, 11, 13), 'stage2', '1.0', '2.0', '99', false)
    self.application_fully_invoiced = true
    self.application_cancelled = false
    sleep(1)
  end

  def fill_everything_in_with_other_stuff
    # Add one of everything
    self.application_new_type = 'Q'
    self.application_council = 'the council2 of place2'
    self.application_development_application_number = 'da4321'
    self.application_applicant = 'applicant2 from firm2'
    self.application_owner = 'owner2 lastname2'
    self.application_contact = 'contact2 of group2'
    self.application_description = 'they went somewhere'
    self.application_administration_notes = 'no notes here'
    self.application_number_of_storeys = '5'
    self.application_construction_value = '44.0'
    self.application_lot_number = '5'
    self.application_street_number = '89'
    self.application_street_name = 'Rondonelli Street'
    self.application_suburb = 'SUBURB2, SA XXXX'
    self.application_fee_amount = '4453.0'
    self.application_electronic_lodgement = false
    self.application_engagement_form = false
    self.application_job_type_administration = 'Commercial'
    self.application_quote_accepted_date = Date.new(2022, 8, 3)
    self.application_applicant_email = 'hello@email.com'
    self.application_risk_rating = 'Low'
    application_remove_additional_information
    application_remove_additional_information
    application_add_additional_information(Date.new(2022, 8, 1), 'No added info')
    application_add_additional_information(Date.new(2023, 8, 1), 'Nothing')
    application_remove_uploaded
    application_remove_uploaded
    application_add_uploaded(Date.new(2022, 11, 4), 'Approval')
    application_add_uploaded(Date.new(2023, 11, 4), 'Stage')
    self.application_building_surveyor = 'Darryl'
    self.application_assessment_assigned = Date.new(2022, 8, 5)
    self.application_structural_engineer = 'Internal'
    self.application_external_engineer_date = Date.new(2022, 8, 6)
    application_remove_rfi
    application_remove_rfi
    application_add_rfi(Date.new(2022, 8, 7))
    application_add_rfi(Date.new(2023, 8, 7))
    application_remove_stage
    application_remove_stage
    application_add_stage(Date.new(2022, 8, 8), 'Stage 1')
    application_add_stage(Date.new(2023, 8, 8), 'Stage 2')
    self.application_consultancies_review_inspection = Date.new(2021, 4, 29)
    self.application_consultancies_report_sent = Date.new(2021, 4, 28)
    self.application_consent_issued = Date.new(2022, 8, 9)
    self.application_variation_issued = Date.new(2022, 8, 10)
    self.application_coo_issued = Date.new(2022, 8, 11)
    self.application_engineer_certificate_received = Date.new(2022, 8, 12)
    self.application_certification_notes = 'certification went poorly'
    self.application_invoice_to = 'Me'
    self.application_care_of = 'You'
    self.application_invoice_email = 'meyou@email.com'
    self.application_attention = 'the people'
    self.application_purchase_order_number = '66'
    self.application_invoice_debtor_notes = 'No debtor notes'
    application_remove_invoice
    application_remove_invoice
    application_add_invoice(Date.new(2022, 10, 13), 'stage3', '43.2', '3', '66', false)
    application_add_invoice(Date.new(2023, 10, 13), 'stage4', '', '3.0', '67', true)
    self.application_fully_invoiced = false
    self.application_cancelled = true
    sleep(1)
  end

  def assert_everything_is_filled_in
    assert_application_type('PC')
    assert_application_reference_number('PC9003')
    assert_application_converted_to_from('')
    assert_application_date_entered(Time.zone.now.strftime('%Y-%m-%d'))
    assert_application_council('the council1 of place1')
    assert_application_development_application_number('da1234')
    assert_application_applicant('applicant1 from firm1')
    assert_application_owner('owner1 lastname1')
    assert_application_contact('contact1 of group1')
    assert_application_description('we did something')
    assert_application_administration_notes('admin notes about stuff')
    assert_application_number_of_storeys('3')
    assert_application_construction_value('123500.0')
    assert_application_lot_number('4')
    assert_application_street_number('88')
    assert_application_street_name('Romito Street')
    assert_application_suburb('SUBURB1, SA XXXX')
    assert_application_fee_amount('3453.0')
    assert_application_electronic_lodgement(true)
    assert_application_engagement_form(true)
    assert_application_job_type_administration('Residential')
    assert_application_quote_accepted_date('2022-07-03')
    assert_application_applicant_email('applicant@email.com')
    assert_application_risk_rating('High')
    assert_application_additional_information('2022-07-01', 'Extra added info', at: 0)
    assert_application_additional_information('2023-07-01', 'Even more info', at: 1)
    assert_application_uploaded('2022-10-04', 'COO', at: 0)
    assert_application_uploaded('2023-10-04', 'Variation', at: 1)
    assert_application_building_surveyor('Vic')
    assert_application_assessment_assigned('2022-07-05')
    assert_application_structural_engineer('External')
    assert_application_external_engineer_date('2022-07-06')
    assert_application_rfi('2022-07-07', at: 0)
    assert_application_rfi('2023-07-07', at: 1)
    assert_application_stage('2022-07-08', 'Substructure', at: 0)
    assert_application_stage('2023-07-08', 'Superstructure', at: 1)
    assert_application_consultancies_review_inspection('2021-03-29')
    assert_application_consultancies_report_sent('2021-03-28')
    assert_application_consent_issued('2022-07-09')
    assert_application_variation_issued('2022-07-10')
    assert_application_coo_issued('2022-07-11')
    assert_application_engineer_certificate_received('2022-07-12')
    assert_application_certification_notes('certification went well')
    assert_application_invoice_to('this person')
    assert_application_care_of('that guy')
    assert_application_invoice_email('guyperson@email.com')
    assert_application_attention('the bosses')
    assert_application_purchase_order_number('5554')
    assert_application_invoice_debtor_notes('debtor notes this that other')
    assert_application_invoice('2022-11-13', 'stage1', '12', '1.2', '', '55', true, at: 0)
    assert_application_invoice('2023-11-13', 'stage2', '1', '0.1', '2', '99', false, at: 1)
    assert_application_invoice_total('$ 13.00', '$ 1.30', '$ 2.00')
    assert_application_fully_invoiced(true)
    assert_application_cancelled(false)
  end

  def assert_everything_has_changed
    assert_no_application_type('PC')
    assert_no_application_reference_number('PC9003')
    assert_no_application_date_entered('1905-05-05')
    assert_no_application_council('the council1 of place1')
    assert_no_application_development_application_number('da1234')
    assert_no_application_applicant('applicant1 from firm1')
    assert_no_application_owner('owner1 lastname1')
    assert_no_application_contact('contact1 of group1')
    assert_no_application_description('we did something')
    assert_no_application_administration_notes('admin notes about stuff')
    assert_no_application_number_of_storeys('3')
    assert_no_application_construction_value('123500.0')
    assert_no_application_lot_number('4')
    assert_no_application_street_number('88')
    assert_no_application_street_name('Romito Street')
    assert_no_application_suburb('SUBURB1, SA XXXX')
    assert_no_application_fee_amount('3453.0')
    assert_no_application_electronic_lodgement(true)
    assert_no_application_engagement_form(true)
    assert_no_application_job_type_administration('Residential')
    assert_no_application_quote_accepted_date('2022-07-03')
    assert_no_application_applicant_email('applicant@email.com')
    assert_no_application_risk_rating('High')
    assert_no_application_additional_information('2022-07-01', 'Extra added info', at: 0)
    assert_no_application_additional_information('2023-07-01', 'Even more info', at: 1)
    assert_no_application_uploaded('2022-10-04', 'COO', at: 0)
    assert_no_application_uploaded('2023-10-04', 'Variation', at: 1)
    assert_no_application_building_surveyor('Vic')
    assert_no_application_assessment_assigned('2022-07-05')
    assert_no_application_structural_engineer('External')
    assert_no_application_external_engineer_date('2022-07-06')
    assert_no_application_rfi('2022-07-07', at: 0)
    assert_no_application_rfi('2023-07-07', at: 1)
    assert_no_application_stage('2022-07-08', 'Substructure', at: 0)
    assert_no_application_stage('2023-07-08', 'Superstructure', at: 1)
    assert_no_application_consultancies_review_inspection('2021-03-29')
    assert_no_application_consultancies_report_sent('2021-03-28')
    assert_no_application_consent_issued('2022-07-09')
    assert_no_application_variation_issued('2022-07-10')
    assert_no_application_coo_issued('2022-07-11')
    assert_no_application_engineer_certificate_received('2022-07-12')
    assert_no_application_certification_notes('certification went well')
    assert_no_application_invoice_to('this person')
    assert_no_application_care_of('that guy')
    assert_no_application_invoice_email('guyperson@email.com')
    assert_no_application_attention('the bosses')
    assert_no_application_purchase_order_number('5554')
    assert_no_application_invoice_debtor_notes('debtor notes this that other')
    assert_no_application_invoice('2022-11-13', 'stage1', '12', '1.2', '', '55', true, at: 0)
    assert_no_application_invoice('2023-11-13', 'stage2', '1', '0.1', '2', '99', false, at: 1)
    assert_no_application_invoice_total('$ 13.00', '$ 1.30', '$ 2.00')
    assert_no_application_fully_invoiced(true)
    assert_no_application_cancelled(false)
  end

  test 'creating a new application saves all fields' do
    sign_in_test_user

    new_application
    fill_everything_in
    assert_everything_is_filled_in
    fill_everything_in_with_other_stuff
    assert_everything_has_changed
    exit_application

    new_application
    fill_everything_in
    assert_everything_is_filled_in
    save_new_application

    assert_on_homepage
    edit_application 'PC9003'
    assert_everything_is_filled_in
  end

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
end
