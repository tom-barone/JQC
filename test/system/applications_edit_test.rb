# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
  test 'selecting and adding a new council' do
    sign_in_test_user

    edit_application 'PC9001'
    assert_field_has_value(
      '#application_council_name',
      'the council1 of place1'
    )

    select 'the council2 of place2', from: 'application_council_name'
    click_on 'Save'
    assert_on_homepage

    assert_text 'the council2 of place2'

    edit_application 'PC9001'
    assert_field_has_value(
      '#application_council_name',
      'the council2 of place2'
    )
    fill_in 'application_council_name', with: 'a completely new council'
    click_on 'Save'
    assert_on_homepage

    assert_text 'a completely new council'

    edit_application 'PC9001'
    fill_in 'application_council_name', with: ''
    click_on 'Save'
    assert_on_homepage

    assert_no_text 'a completely new council'
  end

  test 'selecting and adding new clients' do
    sign_in_test_user

    # Check correct fields
    edit_application 'PC9001'
    assert_field_has_value(
      '#application_applicant_name',
      'applicant1 from firm1'
    )
    assert_field_has_value('#application_owner_name', 'owner1 lastname1')
    assert_field_has_value('#application_client_name', 'contact1 of group1')

    # Choose new client settings
    select 'applicant2 from firm2', from: 'application_applicant_name'
    select 'owner2 lastname2',      from: 'application_owner_name'
    select 'contact2 of group2',    from: 'application_client_name'
    click_on 'Save'
    assert_on_homepage

    # Check they're visible in the table
    assert_text 'applicant2 from firm2'
    assert_text 'owner2 lastname2'
    assert_text 'contact2 of group2'

    # Add completely new clients
    edit_application 'PC9001'
    assert_field_has_value(
      '#application_applicant_name',
      'applicant2 from firm2'
    )
    assert_field_has_value('#application_owner_name', 'owner2 lastname2')
    assert_field_has_value('#application_client_name', 'contact2 of group2')
    select 'newClient1', from: 'application_applicant_name'
    select 'newClient1',      from: 'application_owner_name'
    select 'newClient1',    from: 'application_client_name'
    click_on 'Save'
    assert_on_homepage

    assert_text 'newClient1', count: 3
  end

  test 'converting to a new application type' do
    sign_in_test_user

    edit_application 'PC9002'
    assert_field_has_value('#application_reference_number', 'PC9002')

    fill_in 'application_description', with: "I'm converted!"
    accept_confirm { select 'Q', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'Q8003')
    assert_field_has_value('#application_converted_to_from', 'Auto generated')

    fill_in 'application_administration_notes', with: 'The admin has been too!'
    click_on 'Save'

    select 'Q', from: 'type'
    click_on 'Search'
    assert_text 'Q8003'
    assert_text 'Q8002'
    assert_text 'Q8001'

    edit_application 'Q8003'

    assert_field_has_value('#application_converted_to_from', 'PC9002')
    assert_text "I'm converted!"
    assert_text 'The admin has been too!'

    click_on 'Save'

    select 'PC', from: 'type'
    click_on 'Search'
    assert_text 'PC9002'
    edit_application 'PC9002'
    assert_field_has_value('#application_converted_to_from', 'Q8003')
    assert_text "I'm converted!"
    assert_text 'The admin has been too!'

    click_on 'Save'

    edit_application 'PC9001'
    accept_confirm { select 'Q', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'Q8004')
    assert_field_has_value('#application_converted_to_from', 'Auto generated')
  end

  test 'converting to a different application types does not break ' do
    sign_in_test_user

    edit_application 'PC9001'
    accept_confirm { select 'LG', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'LG6003')
    accept_confirm { select 'RC', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'RC2091')
    accept_confirm { select 'LG', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'LG6003')

    click_on 'Save'

    edit_application 'PC5999'
    accept_confirm { select 'RC', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'RC2091')
    accept_confirm { select 'LG', from: 'application_application_type_id' }
    assert_field_has_value('#application_reference_number', 'LG6004')
  end
end
