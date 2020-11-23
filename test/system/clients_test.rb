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

    fill_in "Abn", with: @client.ABN
    check "Badpayer" if @client.BadPayer
    fill_in "Clientname", with: @client.ClientName
    fill_in "Clienttype", with: @client.ClientType
    fill_in "Companyname", with: @client.CompanyName
    fill_in "Email", with: @client.Email
    fill_in "Fax", with: @client.Fax
    fill_in "Firstname", with: @client.FirstName
    fill_in "Initials", with: @client.Initials
    fill_in "Mobileno", with: @client.MobileNo
    fill_in "Notes", with: @client.Notes
    fill_in "Phone", with: @client.Phone
    fill_in "Postaladdress", with: @client.PostalAddress
    fill_in "Postalsuburbid", with: @client.PostalSuburbID
    fill_in "Salutation", with: @client.Salutation
    fill_in "State", with: @client.State
    fill_in "Street", with: @client.Street
    fill_in "Suburbid", with: @client.SuburbID
    fill_in "Surname", with: @client.Surname
    fill_in "Title", with: @client.Title
    click_on "Create Client"

    assert_text "Client was successfully created"
    click_on "Back"
  end

  test "updating a Client" do
    visit clients_url
    click_on "Edit", match: :first

    fill_in "Abn", with: @client.ABN
    check "Badpayer" if @client.BadPayer
    fill_in "Clientname", with: @client.ClientName
    fill_in "Clienttype", with: @client.ClientType
    fill_in "Companyname", with: @client.CompanyName
    fill_in "Email", with: @client.Email
    fill_in "Fax", with: @client.Fax
    fill_in "Firstname", with: @client.FirstName
    fill_in "Initials", with: @client.Initials
    fill_in "Mobileno", with: @client.MobileNo
    fill_in "Notes", with: @client.Notes
    fill_in "Phone", with: @client.Phone
    fill_in "Postaladdress", with: @client.PostalAddress
    fill_in "Postalsuburbid", with: @client.PostalSuburbID
    fill_in "Salutation", with: @client.Salutation
    fill_in "State", with: @client.State
    fill_in "Street", with: @client.Street
    fill_in "Suburbid", with: @client.SuburbID
    fill_in "Surname", with: @client.Surname
    fill_in "Title", with: @client.Title
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
