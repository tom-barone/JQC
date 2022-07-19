# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    @application = applications(:application_1)
    sign_in_test_user
  end

  test 'Visiting the applications & root page shows the application table' do
    visit applications_url
    assert_selector 'h1', text: 'Applications'
  end

  # test 'creating a Application' do
  # skip
  # visit applications_url
  # click_on 'New Application'

  # fill_in 'Administration notes', with: @application.administration_notes
  # fill_in 'Applicant council', with: @application.applicant_council_id
  # fill_in 'Applicant email', with: @application.applicant_email
  # fill_in 'Applicant', with: @application.applicant_id
  # fill_in 'Application type', with: @application.application_type
  # fill_in 'Assesment commenced', with: @application.assesment_commenced
  # fill_in 'Attention', with: @application.attention
  # fill_in 'Building surveyor', with: @application.building_surveyor
  # check 'Cancelled' if @application.cancelled
  # fill_in 'Care of', with: @application.care_of
  # fill_in 'Certification notes', with: @application.certification_notes
  # fill_in 'Certifier', with: @application.certifier
  # fill_in 'Client council', with: @application.client_council_id
  # fill_in 'Client', with: @application.client_id
  # fill_in 'Consent', with: @application.consent
  # fill_in 'Consent issued', with: @application.consent_issued
  # fill_in 'Converted to from', with: @application.converted_to_from
  # fill_in 'Coo issued', with: @application.coo_issued
  # fill_in 'Council', with: @application.council_id
  # fill_in 'Description', with: @application.description
  # fill_in 'Development application number', with: @application.development_application_number
  # check 'Electronic lodgement' if @application.electronic_lodgement
  # fill_in 'Fee amount', with: @application.fee_amount
  # check 'Fully invoiced' if @application.fully_invoiced
  # check 'Hard copy' if @application.hard_copy
  # fill_in 'Invoice debtor notes', with: @application.invoice_debtor_notes
  # fill_in 'Invoice email', with: @application.invoice_email

  # fill_in 'Invoice to', with: @application.invoice_to
  # fill_in 'Job type', with: @application.job_type
  # fill_in 'Job type administration', with: @application.job_type_administration
  # fill_in 'Lot number', with: @application.lot_number
  # fill_in 'Owner council', with: @application.owner_council_id
  # fill_in 'Owner', with: @application.owner_id
  # fill_in 'Purchase order number', with: @application.purchase_order_number
  # fill_in 'Quote accepted date', with: @application.quote_accepted_date
  # fill_in 'Reference number', with: @application.reference_number
  # fill_in 'Request for information issued', with: @application.request_for_information_issued
  # fill_in 'Risk rating', with: @application.risk_rating
  # fill_in 'Section 93a', with: @application.section_93A
  # fill_in 'Sort priority gen', with: @application.sort_priority_gen
  # fill_in 'Staged', with: @application.staged
  # fill_in 'Street name', with: @application.street_name
  # fill_in 'Street number', with: @application.street_number
  # fill_in 'Structural engineer', with: @application.structural_engineer
  # fill_in 'Suburb', with: @application.suburb_id
  # fill_in 'Variation issued', with: @application.variation_issued
  # click_on 'Create Application'

  # assert_text 'Application was successfully created'
  # click_on 'Back'
  # end
end
