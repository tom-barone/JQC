# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
  test 'selecting and adding a new council' do
    sign_in_test_user

    # Check correct fields and datalist options
    edit_application 'PC9001'
    assert_field_has_value(
      '#application_council_name',
      'the council1 of place1'
    )
    assert_datalist_option_exists('councils', 'the council1 of place1')
    assert_datalist_option_exists('councils', 'the council2 of place2')

    # Choose a new council
    select 'the council2 of place2', from: 'application_council_name'
    click_on 'Save'
    assert_on_homepage

    # Check visible in the application table
    assert_text 'the council2 of place2'

    # Add a new council
    edit_application 'PC9001'
    assert_field_has_value(
      '#application_council_name',
      'the council2 of place2'
    )
    fill_in 'application_council_name', with: 'a completely new council'
    click_on 'Save'
    assert_on_homepage

    # Check new council visible in the application table
    assert_text 'a completely new council'

    # Check they are now selectable in the dropdown for councils
    edit_application 'PC9001'
    assert_datalist_option_exists('councils', 'a completely new council')

    # Check remove
    fill_in 'application_council_name', with: ''
    click_on 'Save'
    assert_on_homepage
    assert_no_text 'a completely new council'
  end

  test 'selecting and adding new clients' do
    sign_in_test_user

    # Check correct fields and datalist options
    edit_application 'PC9001'
    assert_field_has_value(
      '#application_applicant_name',
      'applicant1 from firm1'
    )
    assert_field_has_value('#application_owner_name', 'owner1 lastname1')
    assert_field_has_value('#application_client_name', 'contact1 of group1')
    assert_datalist_option_exists('clients', 'contact1 of group1')
    assert_datalist_option_exists('clients', 'contact2 of group2')
    assert_datalist_option_exists('clients', 'owner1 lastname1')
    assert_datalist_option_exists('clients', 'owner2 lastname2')
    assert_datalist_option_exists('clients', 'applicant1 from firm1')
    assert_datalist_option_exists('clients', 'applicant2 from firm2')

    # Choose new client settings
    select 'applicant2 from firm2', from: 'application_applicant_name'
    select 'owner2 lastname2', from: 'application_owner_name'
    select 'contact2 of group2', from: 'application_client_name'
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
    fill_in 'application_applicant_name', with: 'newClient1'
    fill_in 'application_owner_name', with: 'newClient2'
    fill_in 'application_client_name', with: 'newClient1'
    click_on 'Save'
    assert_on_homepage

    # Check they show up in the applications table
    assert_text 'newClient1', count: 2
    assert_text 'newClient2', count: 1

    # Check they are now selectable in the dropdown for clients
    edit_application 'PC9002'
    assert_datalist_option_exists('clients', 'newClient1')
    assert_datalist_option_exists('clients', 'newClient2')

    # Check remove
    fill_in 'application_applicant_name', with: 'newClient1'
    fill_in 'application_owner_name', with: 'newClient2'
    fill_in 'application_client_name', with: 'newClient1'
    click_on 'Save'
    assert_on_homepage
    assert_no_text 'newClient1'
    assert_no_text 'newClient2'
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

  test 'adding ApplicationAdditionalInformations to the application' do
    sign_in_test_user
    edit_application 'PC9001'

    # Create new additional information
    within('.additional-information-table') do
      click_on 'Add'

      # Check correct fields are shown
      assert_selector('input[type="date"]', count: 1)
      assert_selector('input[type="text"]', count: 1)

      # Check correct fields are shown after another Add
      click_on 'Add'
      assert_selector('input[type="date"]', count: 2)
      assert_selector('input[type="text"]', count: 2)

      # Fillout the fields and save
      dates = all('input[type="date"]')
      texts = all('input[type="text"]')
      dates[0].fill_in with: '01/03/2021'
      dates[1].fill_in with: '23/11/2022'
      texts[0].fill_in with: 'Some information about something'
      texts[1].fill_in with: 'More details about something else'
    end
    click_on 'Save'

    edit_application 'PC9001'
    within('.additional-information-table') do
      # Check the fields are displayed
      assert_all_of_selectors(
        'input[value="2021-03-01"]',
        'input[value="2022-11-23"]',
        'input[value="Some information about something"]',
        'input[value="More details about something else"]'
      )

      # Delete one field and save
      first('.remove_fields').click
    end
    click_on 'Save'

    edit_application 'PC9001'
    within('.additional-information-table') do
      # Check only one field remaining
      assert_selector('input[type="date"]', count: 1)
      assert_selector('input[type="text"]', count: 1)
      assert_all_of_selectors(
        'input[value="2022-11-23"]',
        'input[value="More details about something else"]'
      )
      assert_none_of_selectors(
        'input[value="2021-03-01"]',
        'input[value="Some information about something"]'
      )

      # Make some random changes but don't save them
      first('.remove_fields').click
      click_on 'Add'
      click_on 'Add'
      dates = all('input[type="date"]')
      texts = all('input[type="text"]')
      dates[0].fill_in with: '09/09/2009'
      dates[1].fill_in with: '05/05/2005'
      texts[0].fill_in with: 'I should not save'
      texts[1].fill_in with: 'Neither should I'
    end
    accept_confirm { click_on 'Exit' }

    # Check the original changes remain
    edit_application 'PC9001'
    within('.additional-information-table') do
      # Check only one field remaining
      assert_selector('input[type="date"]', count: 1)
      assert_selector('input[type="text"]', count: 1)
      assert_all_of_selectors(
        'input[value="2022-11-23"]',
        'input[value="More details about something else"]'
      )
      assert_none_of_selectors(
        'input[value="2021-03-01"]',
        'input[value="2009-09-09"]',
        'input[value="2005-05-05"]',
        'input[value="I should not save"]',
        'input[value="Neither should I"]'
      )
    end
  end
end
