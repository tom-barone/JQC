# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationTypesTest < ApplicationSystemTestCase
  test 'selecting and adding a new council' do
    # TODO: Refactor all the other tests to use this format
    sign_in_test_user

    # Check correct fields and datalist options
    edit_application 'PC9001'
    assert application_council == 'the council1 of place1'
    assert_can_select 'the council1 of place1', from: 'councils'
    assert_can_select 'the council2 of place2', from: 'councils'

    # Choose a different council
    self.application_council = 'the council2 of place2'
    save_application

    # Check visible in the application table
    assert_in_homepage_table 'the council2 of place2'

    # Add a new council
    edit_application 'PC9001'
    assert application_council == 'the council2 of place2'
    new_application_council 'a completely new council'
    save_application

    # Check new council visible in the application table
    assert_in_homepage_table 'a completely new council'

    # Check they are now selectable in the dropdown for councils
    edit_application 'PC9001'
    assert_can_select 'a completely new council', from: 'councils'

    # Check remove
    new_application_council ''
    save_application
    assert_on_homepage
    assert_not_in_homepage_table 'a completely new council'
  end

  test 'selecting and adding new clients' do
    sign_in_test_user

    # Check correct fields and datalist options
    edit_application 'PC9001'
    assert application_applicant == 'applicant1 from firm1'
    assert application_owner == 'owner1 lastname1'
    assert application_contact == 'contact1 of group1'

    assert_can_select 'contact1 of group1', from: 'clients'
    assert_can_select 'contact2 of group2', from: 'clients'
    assert_can_select 'owner1 lastname1', from: 'clients'
    assert_can_select 'owner2 lastname2', from: 'clients'
    assert_can_select 'applicant1 from firm1', from: 'clients'
    assert_can_select 'applicant2 from firm2', from: 'clients'

    # Choose new client settings
    self.application_applicant = 'applicant2 from firm2'
    self.application_owner = 'owner2 lastname2'
    self.application_contact = 'contact2 of group2'
    save_application
    assert_on_homepage

    # Check they're visible in the table
    assert_in_homepage_table 'applicant2 from firm2'
    assert_in_homepage_table 'owner2 lastname2'
    assert_in_homepage_table 'contact2 of group2'

    # Add completely new clients
    edit_application 'PC9001'
    assert application_applicant == 'applicant2 from firm2'
    assert application_owner == 'owner2 lastname2'
    assert application_contact == 'contact2 of group2'

    new_application_applicant 'newClient1'
    new_application_owner 'newClient2'
    new_application_contact 'newClient1'
    save_application
    assert_on_homepage

    # Check they show up in the applications table
    assert_in_homepage_table 'newClient1', count: 2
    assert_in_homepage_table 'newClient2', count: 1

    # Check they are now selectable in the dropdown for clients
    edit_application 'PC9001'
    assert_can_select 'newClient1', from: 'clients'
    assert_can_select 'newClient2', from: 'clients'

    # Check remove
    new_application_applicant ''
    new_application_owner ''
    new_application_contact ''
    save_application
    assert_on_homepage
    assert_not_in_homepage_table 'newClient1'
    assert_not_in_homepage_table 'newClient2'
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

  test 'converting to a different application type does not break ' do
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

  test 'saving deleting and exiting works as expected' do
    # TODO: Add a god test that checks every single field saves properly
    sign_in_test_user

    edit_application 'PC9001'
    assert application_description == 'Some demolition happened here'
    self.application_description = 'A changed description'
    save_application
    assert_in_homepage_table 'A changed description'

    edit_application 'PC9001'
    self.application_description = 'An unsaved description'
    exit_application
    assert_on_homepage
    assert_in_homepage_table 'A changed description'
    assert_not_in_homepage_table 'An unsaved description'

    edit_application 'PC9001'
    delete_application
    assert_on_homepage
    assert_not_in_homepage_table 'PC9001'
    assert_not_in_homepage_table 'A changed description'
  end

  test 'client side validiation of form fields' do
    sign_in_test_user

    edit_application 'PC9001'
    self.application_number_of_storeys = '999999999'
    save_application

    assert_validation_message(
      'application_number_of_storeys',
      shows: 'Value must be less than or equal to 99.'
    )

    # The button shouldn't be stuck on saving
    assert_no_text 'Saving...'
    assert_text 'Save'

    # Removing problem allows save
    self.application_number_of_storeys = '1'
    save_application
    assert_on_homepage

    # Can exit and it won't complain
    edit_application 'PC9001'
    assert application_number_of_storeys == '1'
    self.application_number_of_storeys = '999999999'
    self.application_description = 'Something' # fixes click issue
    exit_application
    assert_on_homepage

    # Can delete and it won't complain
    edit_application 'PC9001'
    assert application_number_of_storeys == '1'
    self.application_number_of_storeys = '999999999'
    self.application_description = 'Something else' # fixes click issue
    delete_application
    assert_on_homepage
    assert_not_in_homepage_table 'PC9001'
  end
end
