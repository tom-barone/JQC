# frozen_string_literal: true

require 'selenium-webdriver'

class BrowserTestCase < ActionDispatch::SystemTestCase
  # rubocop:disable Style/SingleLineMethods, Layout/LineLength, Style/Semicolon, Layout/EmptyLineBetweenDefs, Metrics/ParameterLists, Style/CommentedKeyword

  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('--headless')
  driven_by :selenium, using: :chrome, screen_size: [1800, 1000], options: { options: chrome_options }

  Capybara.default_max_wait_time = 20 # Seconds

  @@username = Rails.application.credentials.jqc_username!
  @@password = Rails.application.credentials.jqc_password!

  # Don't put this in a setup {} block! Call manually in every single test
  def sign_in_test_user
    visit root_path
    assert_text('Remember me')
    fill_in 'Username', with: @@username
    fill_in 'Password', with: @@password
    click_on 'Sign in'
    assert_text('Sign out')
  end

  # Homepage actions
  def edit_application(reference_number) find("#row-#{reference_number}").click; sleep(4); assert_on_application_edit_page end
  def new_application()                  click_on 'New Application';             sleep(4); assert_on_application_new_page end
  def homepage_search()                  click_on 'Search';                      sleep(8) end
  def go_to_settings_page()              click_on 'Settings';                    sleep(4) end
  def homepage_search_clear()            click_on 'clear-search'                          end

  # Homepage setters
  def homepage_search_type=(type)       select type, from: 'type' end
  def homepage_search_start_date=(date) fill_in 'start_date', with: date end
  def homepage_search_end_date=(date)   fill_in 'end_date', with: date end
  def homepage_search_text=(text)       fill_in 'search_text', with: text end

  # Homepage positive assertions
  def assert_on_homepage()                    assert_text('New Application') end
  def assert_in_homepage_table(...)           within('.applications-table') { assert_text(...) } end
  def assert_homepage_search_type(type)       assert_selector("option[value='#{type}'][selected='selected']") end
  def assert_homepage_search_start_date(date) assert_selector("#start_date[value='#{date}']") end
  def assert_homepage_search_end_date(date)   assert_selector("#end_date[value='#{date}']") end
  def assert_homepage_search_text(text)       assert_selector("#search_text[value='#{text}']") end

  # Homepage negative assertions
  def assert_not_on_homepage()                   assert_no_text('New Application') end
  def assert_not_in_homepage_table(...)          within('.applications-table') { assert_no_text(...) } end
  def assert_no_homepage_search_type(type)       assert_no_selector("option[value='#{type}'][selected='selected']") end
  def assert_no_homepage_search_start_date(date) assert_no_selector("#start_date[value='#{date}']") end
  def assert_no_homepage_search_end_date(date)   assert_no_selector("#end_date[value='#{date}']") end
  def assert_no_homepage_search_text(text)       assert_no_selector("#search_text[value='#{text}']") end

  # Settings page actions
  def update_settings_last_used(last_used, at:) all('.last_used_cell').at(at).fill_in with: last_used end
  def save_settings()                           click_on 'Save'; sleep(2) end
  def exit_settings()                           click_on 'Exit' end

  # Settings page positive assertions
  def assert_on_settings_page()                   assert_text('Last used number') end
  def assert_settings_application_type(type, at:) within(all('.application_type_cell').at(at)) { assert_selector("input[value='#{type}']") } end
  def assert_settings_last_used(last_used, at:)   within(all('.last_used_cell').at(at)) { assert_selector("input[value='#{last_used}']") } end

  # Settings page negative assertions
  def assert_not_on_settings_page() assert_no_text('Last used number') end

  # Clients page actions
  def edit_applicant() click_on('application_applicant_edit') end
  def edit_owner()     click_on('application_owner_edit')     end
  def edit_contact()   click_on('application_contact_edit')   end
  def save_client()    click_on('Save'); sleep(3)             end
  def exit_client()    click_on('Exit')                       end

  # Clients page setters
  def client_name=(name)                      fill_in 'client_client_name', with: name                            end
  def client_type=(type)                      select type, from: 'client_client_type'                             end
  def client_bad_payer=(bad_payer)            bad_payer ? check('client_bad_payer') : uncheck('client_bad_payer') end
  def client_first_name=(first_name)          fill_in 'client_first_name', with: first_name                       end
  def client_surname=(surname)                fill_in 'client_surname', with: surname                             end
  def client_initials=(initials)              fill_in 'client_initials', with: initials                           end
  def client_title=(title)                    fill_in 'client_title', with: title                                 end
  def client_salutation=(salutation)          fill_in 'client_salutation', with: salutation                       end
  def client_company_name=(company_name)      fill_in 'client_company_name', with: company_name                   end
  def client_australian_business_number=(abn) fill_in 'client_australian_business_number', with: abn              end
  def client_state=(state)                    select state, from: 'client_state'                                  end
  def client_phone=(phone)                    fill_in 'client_phone', with: phone                                 end
  def client_fax=(fax)                        fill_in 'client_fax', with: fax                                     end
  def client_mobile_number=(mobile_number)    fill_in 'client_mobile_number', with: mobile_number                 end
  def client_email=(email)                    fill_in 'client_email', with: email                                 end
  def client_street=(street)                  fill_in 'client_street', with: street                               end
  def client_suburb=(suburb)                  select suburb, from: 'client_suburb_display_name'                   end
  def client_postal_address=(postal_address)  fill_in 'client_postal_address', with: postal_address               end
  def client_postal_suburb=(suburb)           select suburb, from: 'client_postal_suburb_display_name'            end
  def client_notes=(notes)                    fill_in 'client_notes', with: notes                                 end

  # Clients page positive assertions
  def assert_on_client_edit_page()                  assert_text('Client Details')                                                                     end
  def assert_edit_applicant_button()                assert_link('application_applicant_edit')                                                         end
  def assert_edit_owner_button()                    assert_link('application_owner_edit')                                                             end
  def assert_edit_contact_button()                  assert_link('application_contact_edit')                                                           end
  def assert_client_name(name)                      assert_field('client_client_name', with: name)                                                    end
  def assert_client_type(type)                      assert_select('client_client_type', selected: type)                                               end
  def assert_client_bad_payer(bad_payer)            bad_payer ? assert_checked_field('client_bad_payer') : assert_unchecked_field('client_bad_payer') end
  def assert_client_first_name(first_name)          assert_field('client_first_name', with: first_name)                                               end
  def assert_client_surname(surname)                assert_field('client_surname', with: surname)                                                     end
  def assert_client_initials(initials)              assert_field('client_initials', with: initials)                                                   end
  def assert_client_title(title)                    assert_field('client_title', with: title)                                                         end
  def assert_client_salutation(salutation)          assert_field('client_salutation', with: salutation)                                               end
  def assert_client_company_name(company_name)      assert_field('client_company_name', with: company_name)                                           end
  def assert_client_australian_business_number(abn) assert_field('client_australian_business_number', with: abn)                                      end
  def assert_client_state(state)                    assert_select('client_state', selected: state)                                                    end
  def assert_client_phone(phone)                    assert_field('client_phone', with: phone)                                                         end
  def assert_client_fax(fax)                        assert_field('client_fax', with: fax)                                                             end
  def assert_client_mobile_number(mobile_number)    assert_field('client_mobile_number', with: mobile_number)                                         end
  def assert_client_email(email)                    assert_field('client_email', with: email)                                                         end
  def assert_client_street(street)                  assert_field('client_street', with: street)                                                       end
  def assert_client_suburb(suburb)                  assert_field('client_suburb_display_name', with: suburb)                                          end
  def assert_client_postal_address(postal_address)  assert_field('client_postal_address', with: postal_address)                                       end
  def assert_client_postal_suburb(postal_suburb)    assert_field('client_postal_suburb_display_name', with: postal_suburb)                            end
  def assert_client_notes(notes)                    assert_field('client_notes', with: notes)                                                         end

  # Clients page negative assertions
  def assert_not_on_client_edit_page()  assert_no_text('Client Details')             end
  def assert_no_edit_applicant_button() assert_no_link('application_applicant_edit') end
  def assert_no_edit_owner_button()     assert_no_link('application_owner_edit')     end
  def assert_no_edit_contact_button()   assert_no_link('application_contact_edit')   end
  def assert_no_client_name(name)                      assert_no_field('client_client_name', with: name)                                                    end
  def assert_no_client_type(type)                      assert_no_select('client_client_type', selected: type)                                               end
  def assert_no_client_bad_payer(bad_payer)            bad_payer ? assert_no_checked_field('client_bad_payer') : assert_no_unchecked_field('client_bad_payer') end
  def assert_no_client_first_name(first_name)          assert_no_field('client_first_name', with: first_name)                                               end
  def assert_no_client_surname(surname)                assert_no_field('client_surname', with: surname)                                                     end
  def assert_no_client_initials(initials)              assert_no_field('client_initials', with: initials)                                                   end
  def assert_no_client_title(title)                    assert_no_field('client_title', with: title)                                                         end
  def assert_no_client_salutation(salutation)          assert_no_field('client_salutation', with: salutation)                                               end
  def assert_no_client_company_name(company_name)      assert_no_field('client_company_name', with: company_name)                                           end
  def assert_no_client_australian_business_number(abn) assert_no_field('client_australian_business_number', with: abn)                                      end
  def assert_no_client_state(state)                    assert_no_select('client_state', selected: state)                                                    end
  def assert_no_client_phone(phone)                    assert_no_field('client_phone', with: phone)                                                         end
  def assert_no_client_fax(fax)                        assert_no_field('client_fax', with: fax)                                                             end
  def assert_no_client_mobile_number(mobile_number)    assert_no_field('client_mobile_number', with: mobile_number)                                         end
  def assert_no_client_email(email)                    assert_no_field('client_email', with: email)                                                         end
  def assert_no_client_street(street)                  assert_no_field('client_street', with: street)                                                       end
  def assert_no_client_suburb(suburb)                  assert_no_field('client_suburb_display_name', with: suburb)                                          end
  def assert_no_client_postal_address(postal_address)  assert_no_field('client_postal_address', with: postal_address)                                       end
  def assert_no_client_postal_suburb(postal_suburb)    assert_no_field('client_postal_suburb_display_name', with: postal_suburb)                            end
  def assert_no_client_notes(notes)                    assert_no_field('client_notes', with: notes)                                                         end

  # Application actions
  def save_application() click_on 'Save' end
  def save_new_application() click_on 'Save'; sleep(10) end # Takes ages to save stuff unfortunately
  def delete_application() accept_confirm { click_on 'Delete'; sleep(10) } end
  def exit_application() accept_confirm { click_on 'Exit'; sleep(10) } end
  def click_on_conversion_warning_link(application) find_link("Click to go to #{application}.").click end
  def click_on_go_to_conversion_button() find_link('Go to').click end

  # Application setters
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
  def application_add_additional_information(date, text) within('.additional-information-table') { click_on 'Add'; all('input[type="date"]').last.fill_in with: date; all('input[type="text"]').last.fill_in with: text } end
  def application_remove_additional_information() within('.additional-information-table') { all('.remove_fields').last.click } end
  def application_add_uploaded(date, text) within('.uploaded-table') { click_on 'Add'; all('input[type="date"]').last.fill_in with: date; all('select').last.select text } end
  def application_remove_uploaded() within('.uploaded-table') { all('.remove_fields').last.click } end
  def application_building_surveyor=(building_surveyor) select building_surveyor, from: 'application_building_surveyor' end
  def application_assessment_assigned=(assessment_assigned) fill_in 'application_assessment_commenced', with: assessment_assigned end
  def application_structural_engineer=(structural_engineer) select structural_engineer, from: 'application_structural_engineer' end
  def application_external_engineer_date=(external_engineer_date) fill_in 'application_external_engineer_date', with: external_engineer_date end
  def application_add_rfi(date) within('.rfis-table') { click_on 'Add'; all('input[type="date"]').last.fill_in with: date } end
  def application_remove_rfi() within('.rfis-table') { all('.remove_fields').last.click } end
  def application_add_stage(date, text) within('.stages-table') { click_on 'Add'; all('input[type="date"]').last.fill_in with: date; all('select').last.select text } end
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
  def application_remove_invoice() within('.invoice-table') { all('.remove_fields').last.click } end
  def application_fully_invoiced=(fully_invoiced) fully_invoiced ? check('application_fully_invoiced') : uncheck('application_fully_invoiced') end
  def application_cancelled=(cancelled) cancelled ? check('application_cancelled') : uncheck('application_cancelled') end
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

  # Application positive assertions
  def assert_on_application_edit_page() assert_text('Administration'); assert_text('Delete') end
  def assert_on_application_new_page() assert_text('Administration'); assert_no_text('Delete') end
  def assert_go_to_conversion_button() assert_text 'Go to' end
  def assert_more_recent_conversion_warning(application) assert_text "Warning: The related application #{application} has been updated more recently."; assert_text "Click to go to #{application}." end
  def assert_application_type(type) assert_select('application_application_type_id', selected: type) end
  def assert_application_reference_number(reference_number) assert_field('application_reference_number', with: reference_number) end
  def assert_application_converted_to_from(converted_to_from) assert_field('application_converted_to_from', with: converted_to_from, disabled: :all) end
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
  def assert_application_job_type_administration(job_type_administration) assert_select('application_job_type_administration', selected: job_type_administration) end
  def assert_application_quote_accepted_date(quote_accepted_date) assert_field('application_quote_accepted_date', with: quote_accepted_date) end
  def assert_application_applicant_email(applicant_email) assert_field('application_applicant_email', with: applicant_email) end
  def assert_application_additional_information(date, text, at:) within(all('.additional-information-table .nested-fields').at(at)) { assert_field('Info date', with: date); assert_field('Info text', with: text) } end
  def assert_application_uploaded(date, text, at:) within(all('.uploaded-table .nested-fields').at(at)) { assert_field('Uploaded date', with: date); assert_select('Uploaded text', selected: text) } end
  def assert_application_building_surveyor(building_surveyor) assert_select('application_building_surveyor', selected: building_surveyor) end
  def assert_application_assessment_assigned(assessment_assigned) assert_field('application_assessment_commenced', with: assessment_assigned) end
  def assert_application_structural_engineer(structural_engineer) assert_select('application_structural_engineer', selected: structural_engineer) end
  def assert_application_external_engineer_date(external_engineer_date) assert_field('application_external_engineer_date', with: external_engineer_date) end
  def assert_application_rfi(date, at:) within(all('.rfis-table .nested-fields').at(at)) { assert_field('Request for information date', with: date) } end
  def assert_application_stage(date, text, at:) within(all('.stages-table .nested-fields').at(at)) { assert_field('Stage date', with: date); assert_select('Stage text', selected: text) } end
  def assert_application_risk_rating(risk_rating) assert_select('application_risk_rating', selected: risk_rating) end
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
  def assert_application_fully_invoiced(fully_invoiced) fully_invoiced ? assert_checked_field('application_fully_invoiced') : assert_unchecked_field('application_fully_invoiced') end
  def assert_application_cancelled(cancelled) cancelled ? assert_checked_field('application_cancelled') : assert_unchecked_field('application_cancelled') end
  def assert_application_invoice(invoice_date, stage, fee, insurance_levy, gst, admin_fee, dac, lodgement, invoice_number, paid, at:)
    within(all('.invoice-table .nested-fields').at(at)) do
      assert_field('Invoice date', with: invoice_date)
      assert_field('Stage', with: stage)
      assert_field('Fee', with: fee)
      assert_field('Insurance levy', with: insurance_levy)
      assert_field('Gst', with: gst)
      assert_field('Admin fee', with: admin_fee)
      assert_field('Dac', with: dac)
      assert_field('Lodgement', with: lodgement)
      assert_field('Invoice number', with: invoice_number)
      paid ? assert_checked_field('Paid') : assert_unchecked_field('Paid')
    end
  end
  def assert_application_invoice_total(fee, insurance_levy, gst, admin_fee, dac, lodgement)
    within('.invoice-table') do
      assert_selector('#fee-total', text: fee)
      assert_selector('#insurance-levy-total', text: insurance_levy)
      assert_selector('#gst-total', text: gst)
      assert_selector('#admin-total', text: admin_fee)
      assert_selector('#dac-total', text: dac)
      assert_selector('#lodgement-total', text: lodgement)
    end
  end

  # Application negative assertions
  def assert_no_go_to_conversion_button() assert_no_text 'Go to' end
  def assert_no_more_recent_conversion_warning() assert_no_text 'Warning: The related application', exact: false end
  def assert_no_application_type(type) assert_no_select('application_application_type_id', selected: type) end
  def assert_no_application_reference_number(reference_number) assert_no_field('application_reference_number', with: reference_number) end
  def assert_no_application_converted_to_from(converted_to_from) assert_no_field('application_converted_to_from', with: converted_to_from, disabled: :all) end
  def assert_no_application_date_entered(date_entered) assert_no_field('application_created_at', with: date_entered) end
  def assert_no_application_council(council) assert_no_field('application_council_name', with: council) end
  def assert_no_application_development_application_number(development_application_number) assert_no_field('application_development_application_number', with: development_application_number) end
  def assert_no_application_applicant(applicant) assert_no_field('application_applicant_name', with: applicant) end
  def assert_no_application_owner(owner) assert_no_field('application_owner_name', with: owner) end
  def assert_no_application_contact(contact) assert_no_field('application_client_name', with: contact) end
  def assert_no_application_description(description) assert_no_field('application_description', with: description) end
  def assert_no_application_administration_notes(administration_notes) assert_no_field('application_administration_notes', with: administration_notes) end
  def assert_no_application_number_of_storeys(number_of_storeys) assert_no_field('application_number_of_storeys', with: number_of_storeys) end
  def assert_no_application_construction_value(construction_value) assert_no_field('application_construction_value', with: construction_value) end
  def assert_no_application_lot_number(lot_number) assert_no_field('application_lot_number', with: lot_number) end
  def assert_no_application_street_number(street_number) assert_no_field('application_street_number', with: street_number) end
  def assert_no_application_street_name(street_name) assert_no_field('application_street_name', with: street_name) end
  def assert_no_application_suburb(suburb) assert_no_field('application_suburb_display_name', with: suburb) end
  def assert_no_application_fee_amount(fee_amount) assert_no_field('application_fee_amount', with: fee_amount) end
  def assert_no_application_section_93a(section_93a) assert_no_field('application_section_93A', with: section_93a) end
  def assert_no_application_electronic_lodgement(electronic_lodgement) electronic_lodgement ? assert_no_checked_field('application_electronic_lodgement') : assert_no_unchecked_field('application_electronic_lodgement') end
  def assert_no_application_hard_copy(hard_copy) hard_copy ? assert_no_checked_field('application_hard_copy') : assert_no_unchecked_field('application_hard_copy') end
  def assert_no_application_job_type_administration(job_type_administration) assert_no_select('application_job_type_administration', selected: job_type_administration) end
  def assert_no_application_quote_accepted_date(quote_accepted_date) assert_no_field('application_quote_accepted_date', with: quote_accepted_date) end
  def assert_no_application_applicant_email(applicant_email) assert_no_field('application_applicant_email', with: applicant_email) end
  def assert_no_application_additional_information(date, text, at:) within(all('.additional-information-table .nested-fields').at(at)) { assert_no_field('Info date', with: date); assert_no_field('Info text', with: text) } end
  def assert_no_application_uploaded(date, text, at:) within(all('.uploaded-table .nested-fields').at(at)) { assert_no_field('Uploaded date', with: date); assert_no_select('Uploaded text', selected: text) } end
  def assert_no_application_building_surveyor(building_surveyor) assert_no_select('application_building_surveyor', selected: building_surveyor) end
  def assert_no_application_assessment_assigned(assessment_assigned) assert_no_field('application_assessment_commenced', with: assessment_assigned) end
  def assert_no_application_structural_engineer(structural_engineer) assert_no_select('application_structural_engineer', selected: structural_engineer) end
  def assert_no_application_external_engineer_date(external_engineer_date) assert_no_field('application_external_engineer_date', with: external_engineer_date) end
  def assert_no_application_rfi(date, at:) within(all('.rfis-table .nested-fields').at(at)) { assert_no_field('Request for information date', with: date) } end
  def assert_no_application_stage(date, text, at:) within(all('.stages-table .nested-fields').at(at)) { assert_no_field('Stage date', with: date); assert_no_select('Stage text', selected: text) } end
  def assert_no_application_risk_rating(risk_rating) assert_no_select('application_risk_rating', selected: risk_rating) end
  def assert_no_application_consent_issued(consent_issued) assert_no_field('application_consent_issued', with: consent_issued) end
  def assert_no_application_variation_issued(variation_issued) assert_no_field('application_variation_issued', with: variation_issued) end
  def assert_no_application_coo_issued(coo_issued) assert_no_field('application_coo_issued', with: coo_issued) end
  def assert_no_application_engineer_certificate_received(engineer_certificate_received) assert_no_field('application_engineer_certificate_received', with: engineer_certificate_received) end
  def assert_no_application_certification_notes(certification_notes) assert_no_field('application_certification_notes', with: certification_notes) end
  def assert_no_application_invoice_to(invoice_to) assert_no_field('application_invoice_to', with: invoice_to) end
  def assert_no_application_care_of(care_of) assert_no_field('application_care_of', with: care_of) end
  def assert_no_application_invoice_email(invoice_email) assert_no_field('application_invoice_email', with: invoice_email) end
  def assert_no_application_attention(attention) assert_no_field('application_attention', with: attention) end
  def assert_no_application_purchase_order_number(purchase_order_number) assert_no_field('application_purchase_order_number', with: purchase_order_number) end
  def assert_no_application_invoice_debtor_notes(invoice_debtor_notes) assert_no_field('application_invoice_debtor_notes', with: invoice_debtor_notes) end
  def assert_no_application_fully_invoiced(fully_invoiced) fully_invoiced ? assert_no_checked_field('application_fully_invoiced') : assert_no_unchecked_field('application_fully_invoiced') end
  def assert_no_application_cancelled(cancelled) cancelled ? assert_no_checked_field('application_cancelled') : assert_no_unchecked_field('application_cancelled') end
  def assert_no_application_invoice(invoice_date, stage, fee, insurance_levy, gst, admin_fee, dac, lodgement, invoice_number, paid, at:)
    within(all('.invoice-table .nested-fields').at(at)) do
      assert_no_field('Invoice date', with: invoice_date)
      assert_no_field('Stage', with: stage)
      assert_no_field('Fee', with: fee)
      assert_no_field('Insurance levy', with: insurance_levy)
      assert_no_field('Gst', with: gst)
      assert_no_field('Admin fee', with: admin_fee)
      assert_no_field('Dac', with: dac)
      assert_no_field('Lodgement', with: lodgement)
      assert_no_field('Invoice number', with: invoice_number)
      paid ? assert_no_checked_field('Paid') : assert_no_unchecked_field('Paid')
    end
  end
  def assert_no_application_invoice_total(fee, insurance_levy, gst, admin_fee, dac, lodgement)
    within('.invoice-table') do
      assert_no_selector('#fee-total', text: fee)
      assert_no_selector('#insurance-levy-total', text: insurance_levy)
      assert_no_selector('#gst-total', text: gst)
      assert_no_selector('#admin-total', text: admin_fee)
      assert_no_selector('#dac-total', text: dac)
      assert_no_selector('#lodgement-total', text: lodgement)
    end
  end

  # Used to check datalist options:
  #     assert_can_select 'the council1 of place1', from: 'councils'
  def assert_can_select(text, from:)
    assert_selector("##{from} option[value='#{text}']", visible: :all)
  rescue MiniTest::Assertion
    raise
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

# rubocop:enable Style/SingleLineMethods, Layout/LineLength, Style/Semicolon, Layout/EmptyLineBetweenDefs, Metrics/ParameterLists, Style/CommentedKeyword
