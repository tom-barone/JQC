# frozen_string_literal: true

require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application = applications(:one)
  end

  test 'should get index' do
    get applications_url
    assert_response :success
  end

  test 'should get new' do
    get new_application_url
    assert_response :success
  end

  test 'should create application' do
    assert_difference('Application.count') do
      post applications_url,
           params: { application: { administration_notes: @application.administration_notes,
                                    applicant_email: @application.applicant_email, applicant_id: @application.applicant_id, application_type_id: @application.application_type_id, assessment_commenced: @application.assessment_commenced, attention: @application.attention, building_surveyor: @application.building_surveyor, cancelled: @application.cancelled, care_of: @application.care_of, certification_notes: @application.certification_notes, certifier: @application.certifier, consent_issued: @application.consent_issued, construction_value: @application.construction_value, consultancies_report_sent: @application.consultancies_report_sent, consultancies_review_inspection: @application.consultancies_review_inspection, contact_id: @application.contact_id, converted_to_from: @application.converted_to_from, coo_issued: @application.coo_issued, council_id: @application.council_id, description: @application.description, development_application_number: @application.development_application_number, electronic_lodgement: @application.electronic_lodgement, engagement_form: @application.engagement_form, engineer_certificate_received: @application.engineer_certificate_received, external_engineer_date: @application.external_engineer_date, fee_amount: @application.fee_amount, fully_invoiced: @application.fully_invoiced, invoice_debtor_notes: @application.invoice_debtor_notes, invoice_email: @application.invoice_email, invoice_to: @application.invoice_to, job_type_administration: @application.job_type_administration, lot_number: @application.lot_number, number_of_storeys: @application.number_of_storeys, owner_id: @application.owner_id, purchase_order_number: @application.purchase_order_number, quote_accepted_date: @application.quote_accepted_date, reference_number: @application.reference_number, risk_rating: @application.risk_rating, street_name: @application.street_name, street_number: @application.street_number, structural_engineer: @application.structural_engineer, suburb_id: @application.suburb_id, variation_issued: @application.variation_issued } }
    end

    assert_redirected_to application_url(Application.last)
  end

  test 'should show application' do
    get application_url(@application)
    assert_response :success
  end

  test 'should get edit' do
    get edit_application_url(@application)
    assert_response :success
  end

  test 'should update application' do
    patch application_url(@application),
          params: { application: { administration_notes: @application.administration_notes,
                                   applicant_email: @application.applicant_email, applicant_id: @application.applicant_id, application_type_id: @application.application_type_id, assessment_commenced: @application.assessment_commenced, attention: @application.attention, building_surveyor: @application.building_surveyor, cancelled: @application.cancelled, care_of: @application.care_of, certification_notes: @application.certification_notes, certifier: @application.certifier, consent_issued: @application.consent_issued, construction_value: @application.construction_value, consultancies_report_sent: @application.consultancies_report_sent, consultancies_review_inspection: @application.consultancies_review_inspection, contact_id: @application.contact_id, converted_to_from: @application.converted_to_from, coo_issued: @application.coo_issued, council_id: @application.council_id, description: @application.description, development_application_number: @application.development_application_number, electronic_lodgement: @application.electronic_lodgement, engagement_form: @application.engagement_form, engineer_certificate_received: @application.engineer_certificate_received, external_engineer_date: @application.external_engineer_date, fee_amount: @application.fee_amount, fully_invoiced: @application.fully_invoiced, invoice_debtor_notes: @application.invoice_debtor_notes, invoice_email: @application.invoice_email, invoice_to: @application.invoice_to, job_type_administration: @application.job_type_administration, lot_number: @application.lot_number, number_of_storeys: @application.number_of_storeys, owner_id: @application.owner_id, purchase_order_number: @application.purchase_order_number, quote_accepted_date: @application.quote_accepted_date, reference_number: @application.reference_number, risk_rating: @application.risk_rating, street_name: @application.street_name, street_number: @application.street_number, structural_engineer: @application.structural_engineer, suburb_id: @application.suburb_id, variation_issued: @application.variation_issued } }
    assert_redirected_to application_url(@application)
  end

  test 'should destroy application' do
    assert_difference('Application.count', -1) do
      delete application_url(@application)
    end

    assert_redirected_to applications_url
  end
end
