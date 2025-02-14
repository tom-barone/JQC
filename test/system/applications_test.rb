# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    @application = applications(:one)
  end

  test 'visiting the index' do
    visit applications_url
    assert_selector 'h1', text: 'Applications'
  end

  test 'should create application' do
    visit applications_url
    click_on 'New application'

    fill_in 'Administration notes', with: @application.administration_notes
    fill_in 'Applicant email', with: @application.applicant_email
    fill_in 'Applicant', with: @application.applicant_id
    fill_in 'Application type', with: @application.application_type_id
    fill_in 'Assessment commenced', with: @application.assessment_commenced
    fill_in 'Attention', with: @application.attention
    fill_in 'Building surveyor', with: @application.building_surveyor
    check 'Cancelled' if @application.cancelled
    fill_in 'Care of', with: @application.care_of
    fill_in 'Certification notes', with: @application.certification_notes
    fill_in 'Certifier', with: @application.certifier
    fill_in 'Consent issued', with: @application.consent_issued
    fill_in 'Construction value', with: @application.construction_value
    fill_in 'Consultancies report sent', with: @application.consultancies_report_sent
    fill_in 'Consultancies review inspection', with: @application.consultancies_review_inspection
    fill_in 'Contact', with: @application.contact_id
    fill_in 'Converted to from', with: @application.converted_to_from
    fill_in 'Coo issued', with: @application.coo_issued
    fill_in 'Council', with: @application.council_id
    fill_in 'Description', with: @application.description
    fill_in 'Development application number', with: @application.development_application_number
    check 'Electronic lodgement' if @application.electronic_lodgement
    check 'Engagement form' if @application.engagement_form
    fill_in 'Engineer certificate received', with: @application.engineer_certificate_received
    fill_in 'External engineer date', with: @application.external_engineer_date
    fill_in 'Fee amount', with: @application.fee_amount
    check 'Fully invoiced' if @application.fully_invoiced
    fill_in 'Invoice debtor notes', with: @application.invoice_debtor_notes
    fill_in 'Invoice email', with: @application.invoice_email
    fill_in 'Invoice to', with: @application.invoice_to
    fill_in 'Job type administration', with: @application.job_type_administration
    fill_in 'Lot number', with: @application.lot_number
    fill_in 'Number of storeys', with: @application.number_of_storeys
    fill_in 'Owner', with: @application.owner_id
    fill_in 'Purchase order number', with: @application.purchase_order_number
    fill_in 'Quote accepted date', with: @application.quote_accepted_date
    fill_in 'Reference number', with: @application.reference_number
    fill_in 'Risk rating', with: @application.risk_rating
    fill_in 'Street name', with: @application.street_name
    fill_in 'Street number', with: @application.street_number
    fill_in 'Structural engineer', with: @application.structural_engineer
    fill_in 'Suburb', with: @application.suburb_id
    fill_in 'Variation issued', with: @application.variation_issued
    click_on 'Create Application'

    assert_text 'Application was successfully created'
    click_on 'Back'
  end

  test 'should update Application' do
    visit application_url(@application)
    click_on 'Edit this application', match: :first

    fill_in 'Administration notes', with: @application.administration_notes
    fill_in 'Applicant email', with: @application.applicant_email
    fill_in 'Applicant', with: @application.applicant_id
    fill_in 'Application type', with: @application.application_type_id
    fill_in 'Assessment commenced', with: @application.assessment_commenced
    fill_in 'Attention', with: @application.attention
    fill_in 'Building surveyor', with: @application.building_surveyor
    check 'Cancelled' if @application.cancelled
    fill_in 'Care of', with: @application.care_of
    fill_in 'Certification notes', with: @application.certification_notes
    fill_in 'Certifier', with: @application.certifier
    fill_in 'Consent issued', with: @application.consent_issued
    fill_in 'Construction value', with: @application.construction_value
    fill_in 'Consultancies report sent', with: @application.consultancies_report_sent
    fill_in 'Consultancies review inspection', with: @application.consultancies_review_inspection
    fill_in 'Contact', with: @application.contact_id
    fill_in 'Converted to from', with: @application.converted_to_from
    fill_in 'Coo issued', with: @application.coo_issued
    fill_in 'Council', with: @application.council_id
    fill_in 'Description', with: @application.description
    fill_in 'Development application number', with: @application.development_application_number
    check 'Electronic lodgement' if @application.electronic_lodgement
    check 'Engagement form' if @application.engagement_form
    fill_in 'Engineer certificate received', with: @application.engineer_certificate_received
    fill_in 'External engineer date', with: @application.external_engineer_date
    fill_in 'Fee amount', with: @application.fee_amount
    check 'Fully invoiced' if @application.fully_invoiced
    fill_in 'Invoice debtor notes', with: @application.invoice_debtor_notes
    fill_in 'Invoice email', with: @application.invoice_email
    fill_in 'Invoice to', with: @application.invoice_to
    fill_in 'Job type administration', with: @application.job_type_administration
    fill_in 'Lot number', with: @application.lot_number
    fill_in 'Number of storeys', with: @application.number_of_storeys
    fill_in 'Owner', with: @application.owner_id
    fill_in 'Purchase order number', with: @application.purchase_order_number
    fill_in 'Quote accepted date', with: @application.quote_accepted_date
    fill_in 'Reference number', with: @application.reference_number
    fill_in 'Risk rating', with: @application.risk_rating
    fill_in 'Street name', with: @application.street_name
    fill_in 'Street number', with: @application.street_number
    fill_in 'Structural engineer', with: @application.structural_engineer
    fill_in 'Suburb', with: @application.suburb_id
    fill_in 'Variation issued', with: @application.variation_issued
    click_on 'Update Application'

    assert_text 'Application was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Application' do
    visit application_url(@application)
    click_on 'Destroy this application', match: :first

    assert_text 'Application was successfully destroyed'
  end
end
