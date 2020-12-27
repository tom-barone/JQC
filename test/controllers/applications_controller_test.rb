require "test_helper"

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Sign in
    get "/users/sign_in"
    sign_in users(:test_user)
    post user_session_url
    follow_redirect!
    assert_response :success

    @application = applications(:application_1)
  end

  test "authed users should get index" do
    get applications_url
    assert_response :success
  end

  test "should get new" do
    get new_application_url
    assert_response :success
  end

  test "should create application" do
    assert_difference("Application.count") do
      post applications_url, params: { application: { administration_notes: @application.administration_notes, applicant_council_id: @application.applicant_council_id, applicant_email: @application.applicant_email, applicant_id: @application.applicant_id, application_type_id: @application.application_type_id, assesment_commenced: @application.assesment_commenced, attention: @application.attention, building_surveyor: @application.building_surveyor, cancelled: @application.cancelled, care_of: @application.care_of, certification_notes: @application.certification_notes, certifier: @application.certifier, client_council_id: @application.client_council_id, client_id: @application.client_id, consent: @application.consent, consent_issued: @application.consent_issued, converted_to_from: @application.converted_to_from, coo_issued: @application.coo_issued, council_id: @application.council_id, description: @application.description, development_application_number: @application.development_application_number, electronic_lodgement: @application.electronic_lodgement, fee_amount: @application.fee_amount, fully_invoiced: @application.fully_invoiced, hard_copy: @application.hard_copy, invoice_debtor_notes: @application.invoice_debtor_notes, invoice_email: @application.invoice_email, invoice_to: @application.invoice_to, job_type: @application.job_type, job_type_administration: @application.job_type_administration, lot_number: @application.lot_number, owner_council_id: @application.owner_council_id, owner_id: @application.owner_id, purchase_order_number: @application.purchase_order_number, quote_accepted_date: @application.quote_accepted_date, reference_number: @application.reference_number, request_for_information_issued: @application.request_for_information_issued, risk_rating: @application.risk_rating, section_93A: @application.section_93A, sort_priority_gen: @application.sort_priority_gen, staged: @application.staged, street_name: @application.street_name, street_number: @application.street_number, structural_engineer: @application.structural_engineer, suburb_id: @application.suburb_id, variation_issued: @application.variation_issued } }
    end

    assert_redirected_to application_url(Application.last)
  end

  test "should show application" do
    get application_url(@application)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_url(@application)
    assert_response :success
  end

  test "should update application" do
    patch application_url(@application), params: { application: { administration_notes: @application.administration_notes, applicant_council_id: @application.applicant_council_id, applicant_email: @application.applicant_email, applicant_id: @application.applicant_id, application_type_id: @application.application_type_id, assesment_commenced: @application.assesment_commenced, attention: @application.attention, building_surveyor: @application.building_surveyor, cancelled: @application.cancelled, care_of: @application.care_of, certification_notes: @application.certification_notes, certifier: @application.certifier, client_council_id: @application.client_council_id, client_id: @application.client_id, consent: @application.consent, consent_issued: @application.consent_issued, converted_to_from: @application.converted_to_from, coo_issued: @application.coo_issued, council_id: @application.council_id, description: @application.description, development_application_number: @application.development_application_number, electronic_lodgement: @application.electronic_lodgement, fee_amount: @application.fee_amount, fully_invoiced: @application.fully_invoiced, hard_copy: @application.hard_copy, invoice_debtor_notes: @application.invoice_debtor_notes, invoice_email: @application.invoice_email, invoice_to: @application.invoice_to, job_type: @application.job_type, job_type_administration: @application.job_type_administration, lot_number: @application.lot_number, owner_council_id: @application.owner_council_id, owner_id: @application.owner_id, purchase_order_number: @application.purchase_order_number, quote_accepted_date: @application.quote_accepted_date, reference_number: @application.reference_number, request_for_information_issued: @application.request_for_information_issued, risk_rating: @application.risk_rating, section_93A: @application.section_93A, sort_priority_gen: @application.sort_priority_gen, staged: @application.staged, street_name: @application.street_name, street_number: @application.street_number, structural_engineer: @application.structural_engineer, suburb_id: @application.suburb_id, variation_issued: @application.variation_issued } }
    assert_redirected_to application_url(@application)
  end

  test "should destroy application" do
    assert_difference("Application.count", -1) do
      delete application_url(@application)
    end

    assert_redirected_to applications_url
  end
end
