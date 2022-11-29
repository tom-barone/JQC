# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1800, 1000]

  # driven_by :selenium, using: :chrome, screen_size: [1800, 1000]

  fixtures :all
  Capybara.default_max_wait_time = 15 # Seconds

  # Don't put this in a setup {} block! Call manually in every single test
  def sign_in_test_user
    visit root_path
    assert_text('Remember me')
    fill_in 'Username', with: 'test'
    fill_in 'Password', with: 'test_password'
    click_on 'Sign in'
    assert_text('Sign out')
  end

  def assert_on_homepage
    assert_text('New Application')
  rescue MiniTest::Assertion
    raise
  end

  def assert_in_homepage_table(...)
    within('.applications-table') { assert_text(...) }
  rescue MiniTest::Assertion
    raise
  end

  def assert_not_in_homepage_table(...)
    within('.applications-table') { assert_no_text(...) }
  rescue MiniTest::Assertion
    raise
  end

  # Application setters
  # rubocop:disable Style/SingleLineMethods, Layout/LineLength, Style/Semicolon, Metrics/AbcSize, Layout/EmptyLineBetweenDefs, Metrics/ParameterLists
  def application_type=(application_type) accept_confirm { select application_type, from: 'application_application_type_id' } end
  def application_new_type=(application_type) select application_type, from: 'application_application_type_id' end
  def application_reference_number=(reference_number) fill_in 'application_reference_number', with: reference_number end
  def application_converted_to_from=(converted_to_from) fill_in 'application_converted_to_from', with: converted_to_from end
  def application_date_entered=(date_entered) fill_in 'application_created_at', with: date_entered end
  def application_council=(council) select council, from: 'application_council_name' end
  def application_new_council=(council) fill_in 'application_council_name', with: council end
  def application_development_application_number=(development_application_number) fill_in 'application_development_application_number', with: development_application_number end
  def application_applicant=(applicant) select applicant, from: 'application_applicant_name' end
  def application_new_applicant=(applicant) fill_in 'application_applicant_name', with: applicant end
  def application_owner=(owner) select owner, from: 'application_owner_name' end
  def application_new_owner=(owner) fill_in 'application_owner_name', with: owner end
  def application_contact=(contact) select contact, from: 'application_client_name' end
  def application_new_contact=(contact) fill_in 'application_client_name', with: contact end
  def application_description=(description) fill_in 'application_description', with: description end
  def application_administration_notes=(administration_notes) fill_in 'application_administration_notes', with: administration_notes end
  def application_number_of_storeys=(number_of_storeys) fill_in 'application_number_of_storeys', with: number_of_storeys end
  def application_construction_value=(construction_value) fill_in 'application_construction_value', with: construction_value end
  def application_lot_number=(lot_number) fill_in 'application_lot_number', with: lot_number end
  def application_street_number=(street_number) fill_in 'application_street_number', with: street_number end
  def application_street_name=(street_name) fill_in 'application_street_name', with: street_name end
  def application_suburb=(suburb) select suburb, from: 'application_suburb_display_name' end
  def application_fee_amount=(fee_amount) fill_in 'application_fee_amount', with: fee_amount end
  def application_section_93a=(section_93a) fill_in 'application_section_93A', with: section_93a end
  def application_electronic_lodgement=(electronic_lodgement) electronic_lodgement ? check('application_electronic_lodgement') : uncheck('application_electronic_lodgement') end
  def application_hard_copy=(hard_copy) hard_copy ? check('application_hard_copy') : uncheck('application_hard_copy')  end
  def application_job_type_administration=(job_type_administration) select job_type_administration, from: 'application_job_type_administration' end
  def application_quote_accepted_date=(quote_accepted_date) fill_in 'application_quote_accepted_date', with: quote_accepted_date end
  def application_applicant_email=(applicant_email) fill_in 'application_applicant_email', with: applicant_email end
  def application_add_additional_information(date, text) within('.additional-information-table') { click_on 'Add'; dates = all('input[type="date"]'); texts = all('input[type="text"]'); dates.last.fill_in with: date; texts.last.fill_in with: text } end
  def application_remove_additional_information() within('.additional-information-table') { all('.remove_fields').last.click } end
  def application_add_uploaded(date, text) within('.uploaded-table') { click_on 'Add'; dates = all('input[type="date"]'); texts = all('select'); dates.last.fill_in with: date; texts.last.select text } end
  def application_remove_uploaded() within('.uploaded-table') { all('.remove_fields').last.click } end
  def application_building_surveyor=(building_surveyor) select building_surveyor, from: 'application_building_surveyor' end
  def application_assessment_assigned=(assessment_assigned) fill_in 'application_assessment_commenced', with: assessment_assigned end
  def application_structural_engineer=(structural_engineer) select structural_engineer, from: 'application_structural_engineer' end
  def application_external_engineer_date=(external_engineer_date) fill_in 'application_external_engineer_date', with: external_engineer_date end
  def application_add_rfi(date) within('.rfis-table') { click_on 'Add'; dates = all('input[type="date"]'); dates.last.fill_in with: date } end
  def application_remove_rfi() within('.rfis-table') { all('.remove_fields').last.click } end
  def application_add_stage(date, text) within('.stages-table') { click_on 'Add'; dates = all('input[type="date"]'); texts = all('select'); dates.last.fill_in with: date; texts.last.select text } end
  def application_remove_stage() within('.stages-table') { all('.remove_fields').last.click } end
  def application_risk_rating=(risk_rating) select risk_rating, from: 'application_risk_rating' end
  def application_consent_issued=(consent_issued) fill_in 'application_consent_issued', with: consent_issued end
  def application_variation_issued=(variation_issued) fill_in 'application_variation_issued', with: variation_issued end
  def application_coo_issued=(coo_issued) fill_in 'application_coo_issued', with: coo_issued end
  def application_engineer_certificate_received=(engineer_certificate_received) fill_in 'application_engineer_certificate_received', with: engineer_certificate_received end
  def application_certification_notes=(certification_notes) fill_in 'application_certification_notes', with: certification_notes end
  def application_invoice_to=(invoice_to) fill_in 'application_invoice_to', with: invoice_to end
  def application_care_of=(care_of) fill_in 'application_care_of', with: care_of end
  def application_invoice_email=(invoice_email) fill_in 'application_invoice_email', with: invoice_email end
  def application_attention=(attention) fill_in 'application_attention', with: attention end
  def application_purchase_order_number=(purchase_order_number) fill_in 'application_purchase_order_number', with: purchase_order_number end
  def application_invoice_debtor_notes=(invoice_debtor_notes) fill_in 'application_invoice_debtor_notes', with: invoice_debtor_notes end
  def application_add_invoice(invoice_date, stage, fee, insurance_levy, admin_fee, dac, lodgement, invoice_number, paid)
    within('.invoice-table') { click_on 'Add' }
    within('.invoice-fields') do
      all('.invoice-date-cell input').last.fill_in with: invoice_date
      all('.invoice-stage-cell input').last.fill_in with: stage
      all('.invoice-fee-cell input').last.fill_in with: fee
      all('.invoice-insurance-levy-cell input').last.fill_in with: insurance_levy
      # all('.invoice-gst-cell input').last.fill_in with: gst
      all('.invoice-admin-cell input').last.fill_in with: admin_fee
      all('.invoice-dac-cell input').last.fill_in with: dac
      all('.invoice-lodgement-cell input').last.fill_in with: lodgement
      all('.invoice-invoice-number-cell input').last.fill_in with: invoice_number
      paid ? all('.invoice-paid-cell input[type="checkbox"]').last.check : all('.invoice-paid-cell input[type="checkbox"]').last.uncheck
    end
  end
  def application_remove_invoice() within('.invoice-table') { all('.remove_fields').last.click } end
  def application_fully_invoiced=(fully_invoiced) fully_invoiced ? check('application_fully_invoiced') : uncheck('application_fully_invoiced') end
  def application_cancelled=(cancelled) cancelled ? check('application_cancelled') : uncheck('application_cancelled') end
  # rubocop:enable Style/SingleLineMethods, Layout/LineLength, Style/Semicolon, Metrics/AbcSize, Layout/EmptyLineBetweenDefs, Metrics/ParameterLists

  # Application asserters
  # rubocop:disable Style/SingleLineMethods, Layout/LineLength
  def assert_application_type(type) find(:field, 'application_application_type_id').assert_text(type) end
  def assert_application_reference_number(reference_number) assert_field('application_reference_number', with: reference_number) end
  def assert_application_converted_to_from(converted_to_from) assert_field('application_converted_to_from', with: converted_to_from) end
  def assert_application_date_entered(date_entered) assert_field('application_created_at', with: date_entered) end
  def assert_application_council(council) assert_field('application_council_name', with: council) end
  def assert_application_development_application_number(development_application_number) assert_field('application_development_application_number', with: development_application_number) end
  def assert_application_applicant(applicant) assert_field('application_applicant_name', with: applicant) end
  def assert_application_owner(owner) assert_field('application_owner_name', with: owner) end
  def assert_application_contact(contact) assert_field('application_client_name', with: contact) end
  def assert_application_description(description) assert_field('application_description', with: description) end
  def assert_application_administration_notes(administration_notes) assert_field('application_administration_notes', with: administration_notes) end
  def assert_application_number_of_storeys(number_of_storeys) assert_field('application_number_of_storeys', with: number_of_storeys) end
  def assert_application_construction_value(construction_value) assert_field('application_construction_value', with: construction_value) end
  def assert_application_lot_number(lot_number) assert_field('application_lot_number', with: lot_number) end
  def assert_application_street_number(street_number) assert_field('application_street_number', with: street_number) end
  def assert_application_street_name(street_name) assert_field('application_street_name', with: street_name) end
  def assert_application_suburb(suburb) assert_field('application_suburb_display_name', with: suburb) end
  def assert_application_fee_amount(fee_amount) assert_field('application_fee_amount', with: fee_amount) end
  def assert_application_section_93a(section_93a) assert_field('application_section_93A', with: section_93a) end
  def assert_application_electronic_lodgement(electronic_lodgement) electronic_lodgement ? assert_checked_field('application_electronic_lodgement') : assert_unchecked_field('application_electronic_lodgement') end
  def assert_application_hard_copy(hard_copy) hard_copy ? assert_checked_field('application_hard_copy') : assert_unchecked_field('application_hard_copy') end
  def assert_application_job_type_administration(job_type_administration) find(:field, 'application_job_type_administration').assert_text(job_type_administration) end
  def assert_application_quote_accepted_date(quote_accepted_date) assert_field('application_quote_accepted_date', with: quote_accepted_date) end
  def assert_application_applicant_email(applicant_email) assert_field('application_applicant_email', with: applicant_email) end
  # Additional info
  # Uploaded
  def assert_application_building_surveyor(building_surveyor) find(:field, 'application_building_surveyor').assert_text(building_surveyor) end
  def assert_application_assessment_assigned(assessment_assigned) assert_field('application_assessment_commenced', with: assessment_assigned) end
  def assert_application_structural_engineer(structural_engineer) find(:field, 'application_structural_engineer').assert_text(structural_engineer) end
  def assert_application_external_engineer_date(external_engineer_date) assert_field('application_external_engineer_date', with: external_engineer_date) end
  # RFIS
  # Stages
  def assert_application_risk_rating(risk_rating) find(:field, 'application_risk_rating').assert_text(risk_rating) end
  def assert_application_consent_issued(consent_issued) assert_field('application_consent_issued', with: consent_issued) end
  def assert_application_variation_issued(variation_issued) assert_field('application_variation_issued', with: variation_issued) end
  def assert_application_coo_issued(coo_issued) assert_field('application_coo_issued', with: coo_issued) end
  def assert_application_engineer_certificate_received(engineer_certificate_received) assert_field('application_engineer_certificate_received', with: engineer_certificate_received) end
  def assert_application_certification_notes(certification_notes) assert_field('application_certification_notes', with: certification_notes) end
  def assert_application_invoice_to(invoice_to) assert_field('application_invoice_to', with: invoice_to) end
  def assert_application_care_of(care_of) assert_field('application_care_of', with: care_of) end
  def assert_application_invoice_email(invoice_email) assert_field('application_invoice_email', with: invoice_email) end
  def assert_application_attention(attention) assert_field('application_attention', with: attention) end
  def assert_application_purchase_order_number(purchase_order_number) assert_field('application_purchase_order_number', with: purchase_order_number) end
  def assert_application_invoice_debtor_notes(invoice_debtor_notes) assert_field('application_invoice_debtor_notes', with: invoice_debtor_notes) end
  # Invoices
  def assert_application_fully_invoiced(fully_invoiced) fully_invoiced ? assert_checked_field('application_fully_invoiced') : assert_unchecked_field('application_fully_invoiced') end
  def assert_application_cancelled(cancelled) cancelled ? assert_checked_field('application_cancelled') : assert_unchecked_field('application_cancelled') end

  # For invoicing, stages, uploaded
  # def assert_application_paid(paid) paid ? assert_checked_field('application_paid') : assert_unchecked_field('application_paid') end
  # def assert_application_stages(stages) find(:field, 'application_stages').assert_text(stages) end
  # def assert_application_uploaded(uploaded) find(:field, 'application_uploaded').assert_text(uploaded) end

  ## Method with exception raise
  # def assert_application_reference_number(reference_number) assert_selector("#application_reference_number[value='#{reference_number}']")
  # rescue MiniTest::Assertion
  #   raise
  # end

  # rubocop:enable Style/SingleLineMethods, Layout/LineLength

  def application_council
    find(:field, 'application_council_name').value
  end

  def application_applicant
    find(:field, 'application_applicant_name').value
  end

  def new_application_applicant(applicant)
    fill_in 'application_applicant_name', with: applicant
  end

  def application_owner
    find(:field, 'application_owner_name').value
  end

  def new_application_owner(owner)
    fill_in 'application_owner_name', with: owner
  end

  def application_contact
    find(:field, 'application_client_name').value
  end

  def application_description
    find(:field, 'application_description').text
  end

  def application_number_of_storeys
    find(:field, 'application_number_of_storeys').value
  end

  def save_application
    click_on 'Save'
  end

  def save_new_application
    click_on 'Save'
    # Takes ages to save stuff unfortunately
    sleep(10)
  end

  def delete_application
    accept_confirm { click_on 'Delete' }
  end

  def exit_application
    accept_confirm { click_on 'Exit' }
  end

  def assert_can_select(text, from:)
    assert_selector("##{from} option[value='#{text}']", visible: :all)
  rescue MiniTest::Assertion
    raise
  end

  def edit_application(reference_number)
    assert_text reference_number
    find("#row-#{reference_number}").click
    sleep(4)
    assert_text 'Administration'
  rescue MiniTest::Assertion
    raise
  end

  def new_application
    click_on 'New Application'
    sleep(4)
    assert_text 'Administration'
  rescue MiniTest::Assertion
    raise
  end

  def homepage_search_type=(type)
    select type, from: 'type'
  end

  def homepage_search
    click_on 'Search'
  end

  # Use like
  #   assert_field_has_value('#application_reference_number', 'Q8003')
  def assert_field_has_value(id, str)
    assert_equal(find(id)[:value], str)
  rescue MiniTest::Assertion
    raise
  end

  # Use like
  #   assert_datalist_option_exists('clients', 'applicant1 from firm1')
  def assert_datalist_option_exists(id, value)
    assert_selector("##{id} option[value='#{value}']", visible: :all)
  rescue MiniTest::Assertion
    raise
  end

  def assert_validation_message(field, shows:)
    message = page.find(:field, field).native.attribute('validationMessage')
    assert message == shows
  rescue MiniTest::Assertion
    raise
  end
end
