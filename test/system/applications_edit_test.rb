# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
  def edit_application(reference_number)
    assert_text reference_number
    find('td', text: reference_number).click
    assert_text 'Administration'
  end

  def assert_field_has_value(id, str)
    assert_equal(find(id)[:value], str)
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
