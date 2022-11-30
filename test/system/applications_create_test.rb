# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
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
    self.application_section_93a = '02/07/2022'
    self.application_electronic_lodgement = true
    self.application_hard_copy = true
    self.application_job_type_administration = 'Residential'
    self.application_quote_accepted_date = '03/07/2022'
    self.application_applicant_email = 'applicant@email.com'
    self.application_risk_rating = 'High'
    application_add_additional_information('01/07/2022', 'Extra added info')
    application_add_additional_information('01/07/2023', 'Even more info')
    application_add_uploaded('04/10/2022', 'COO')
    application_add_uploaded('04/10/2023', 'Variation')
    self.application_building_surveyor = 'Vic'
    self.application_assessment_assigned = '05/07/2022'
    self.application_structural_engineer = 'External'
    self.application_external_engineer_date = '06/07/2022'
    application_add_rfi('07/07/2022')
    application_add_rfi('07/07/2023')
    application_add_stage('08/07/2022', 'Substructure')
    application_add_stage('08/07/2023', 'Superstructure')
    self.application_consent_issued = '09/07/2022'
    self.application_variation_issued = '10/07/2022'
    self.application_coo_issued = '11/07/2022'
    self.application_engineer_certificate_received = '12/07/2022'
    self.application_certification_notes = 'certification went well'
    self.application_invoice_to = 'this person'
    self.application_care_of = 'that guy'
    self.application_invoice_email = 'guyperson@email.com'
    self.application_attention = 'the bosses'
    self.application_purchase_order_number = '5554'
    self.application_invoice_debtor_notes = 'debtor notes this that other'
    application_add_invoice('13/11/2022', 'stage1', '12', '44.4', '2', '1.2', '', '55', true)
    application_add_invoice('13/11/2023', 'stage2', '1.0', '82.4', '2.0', '', '', '99', false)
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
    self.application_section_93a = '02/08/2022'
    self.application_electronic_lodgement = false
    self.application_hard_copy = false
    self.application_job_type_administration = 'Commercial'
    self.application_quote_accepted_date = '03/08/2022'
    self.application_applicant_email = 'hello@email.com'
    self.application_risk_rating = 'Low'
    application_remove_additional_information
    application_remove_additional_information
    application_add_additional_information('01/08/2022', 'No added info')
    application_add_additional_information('01/08/2023', 'Nothing')
    application_remove_uploaded
    application_remove_uploaded
    application_add_uploaded('04/11/2022', 'Approval')
    application_add_uploaded('04/11/2023', 'Stage')
    self.application_building_surveyor = 'Ian'
    self.application_assessment_assigned = '05/08/2022'
    self.application_structural_engineer = 'Internal'
    self.application_external_engineer_date = '06/08/2022'
    application_remove_rfi
    application_remove_rfi
    application_add_rfi('07/08/2022')
    application_add_rfi('07/08/2023')
    application_remove_stage
    application_remove_stage
    application_add_stage('08/08/2022', 'Stage 1')
    application_add_stage('08/08/2023', 'Stage 2')
    self.application_consent_issued = '09/08/2022'
    self.application_variation_issued = '10/08/2022'
    self.application_coo_issued = '11/08/2022'
    self.application_engineer_certificate_received = '12/08/2022'
    self.application_certification_notes = 'certification went poorly'
    self.application_invoice_to = 'Me'
    self.application_care_of = 'You'
    self.application_invoice_email = 'meyou@email.com'
    self.application_attention = 'the people'
    self.application_purchase_order_number = '66'
    self.application_invoice_debtor_notes = 'No debtor notes'
    application_remove_invoice
    application_remove_invoice
    application_add_invoice('13/10/2022', 'stage3', '13', '49.4', '3', '3.2', '9', '66', false)
    application_add_invoice('13/10/2023', 'stage4', '3.0', '83.4', '3.0', '9', '10', '67', true)
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
    assert_application_section_93a('2022-07-02')
    assert_application_electronic_lodgement(true)
    assert_application_hard_copy(true)
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
    assert_application_invoice('2022-11-13', 'stage1', '12', '44.4', '5.64', '2', '1.2', '', '55', true, at: 0)
    assert_application_invoice('2023-11-13', 'stage2', '1', '82.4', '8.34', '2', '', '', '99', false, at: 1)
    assert_application_invoice_total('$ 13.00', '$ 126.80', '$ 13.98', '$ 4.00', '$ 1.20', '$ 0.00')
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
    assert_no_application_section_93a('2022-07-02')
    assert_no_application_electronic_lodgement(true)
    assert_no_application_hard_copy(true)
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
    assert_no_application_invoice('2022-11-13', 'stage1', '12', '44.4', '5.64', '2', '1.2', '', '55', true, at: 0)
    assert_no_application_invoice('2023-11-13', 'stage2', '1', '82.4', '8.34', '2', '', '', '99', false, at: 1)
    assert_no_application_invoice_total('$ 13.00', '$ 126.80', '$ 13.98', '$ 4.00', '$ 1.20', '$ 0.00')
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
end
