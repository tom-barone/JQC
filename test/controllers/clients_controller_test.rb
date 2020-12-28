require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_test_user
    @client = clients(:client_1)
    @unused = clients(:unused)
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post clients_url, params: { client: { australian_business_number: @client.australian_business_number, bad_payer: @client.bad_payer, client_name: @client.client_name, client_type: @client.client_type, company_name: @client.company_name, email: @client.email, fax: @client.fax, first_name: @client.first_name, initials: @client.initials, mobile_number: @client.mobile_number, notes: @client.notes, phone: @client.phone, postal_address: @client.postal_address, postal_suburb_id: @client.postal_suburb_id, salutation: @client.salutation, state: @client.state, street: @client.street, suburb_id: @client.suburb_id, surname: @client.surname, title: @client.title } }
    end

    assert_redirected_to client_url(Client.last)
  end

  test "should show client" do
    get client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@client)
    assert_response :success
  end

  test "should update client" do
    patch client_url(@client), params: { client: { australian_business_number: @client.australian_business_number, bad_payer: @client.bad_payer, client_name: @client.client_name, client_type: @client.client_type, company_name: @client.company_name, email: @client.email, fax: @client.fax, first_name: @client.first_name, initials: @client.initials, mobile_number: @client.mobile_number, notes: @client.notes, phone: @client.phone, postal_address: @client.postal_address, postal_suburb_id: @client.postal_suburb_id, salutation: @client.salutation, state: @client.state, street: @client.street, suburb_id: @client.suburb_id, surname: @client.surname, title: @client.title } }
    assert_redirected_to client_url(@client)
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete client_url(@unused)
    end

    assert_redirected_to clients_url
  end
end
