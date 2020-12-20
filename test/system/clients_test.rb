require "application_system_test_case"

class ClientsTest < ApplicationSystemTestCase
  setup do
    @client = clients(:one)
  end

  test "visiting the index" do
    visit clients_url
    assert_selector "h1", text: "Clients"
  end

  test "creating a Client" do
    visit clients_url
    click_on "New Client"

    fill_in "Australian business number", with: @client.australian_business_number
    check "Bad payer" if @client.bad_payer
    fill_in "Client name", with: @client.client_name
    fill_in "Client type", with: @client.client_type
    fill_in "Company name", with: @client.company_name
    fill_in "Email", with: @client.email
    fill_in "Fax", with: @client.fax
    fill_in "First name", with: @client.first_name
    fill_in "Initials", with: @client.initials
    fill_in "Mobile number", with: @client.mobile_number
    fill_in "Notes", with: @client.notes
    fill_in "Phone", with: @client.phone
    fill_in "Postal address", with: @client.postal_address
    fill_in "Postal suburb", with: @client.postal_suburb_id
    fill_in "Salutation", with: @client.salutation
    fill_in "State", with: @client.state
    fill_in "Street", with: @client.street
    fill_in "Suburb", with: @client.suburb_id
    fill_in "Surname", with: @client.surname
    fill_in "Title", with: @client.title
    click_on "Create Client"

    assert_text "Client was successfully created"
    click_on "Back"
  end

  test "updating a Client" do
    visit clients_url
    click_on "Edit", match: :first

    fill_in "Australian business number", with: @client.australian_business_number
    check "Bad payer" if @client.bad_payer
    fill_in "Client name", with: @client.client_name
    fill_in "Client type", with: @client.client_type
    fill_in "Company name", with: @client.company_name
    fill_in "Email", with: @client.email
    fill_in "Fax", with: @client.fax
    fill_in "First name", with: @client.first_name
    fill_in "Initials", with: @client.initials
    fill_in "Mobile number", with: @client.mobile_number
    fill_in "Notes", with: @client.notes
    fill_in "Phone", with: @client.phone
    fill_in "Postal address", with: @client.postal_address
    fill_in "Postal suburb", with: @client.postal_suburb_id
    fill_in "Salutation", with: @client.salutation
    fill_in "State", with: @client.state
    fill_in "Street", with: @client.street
    fill_in "Suburb", with: @client.suburb_id
    fill_in "Surname", with: @client.surname
    fill_in "Title", with: @client.title
    click_on "Update Client"

    assert_text "Client was successfully updated"
    click_on "Back"
  end

  test "destroying a Client" do
    visit clients_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Client was successfully destroyed"
  end
end
