require 'test_helper'

class CouncilsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @council = councils(:one)
  end

  test "should get index" do
    get councils_url
    assert_response :success
  end

  test "should get new" do
    get new_council_url
    assert_response :success
  end

  test "should create council" do
    assert_difference('Council.count') do
      post councils_url, params: { council: { city: @council.city, email: @council.email, fax: @council.fax, name: @council.name, notes: @council.notes, phone: @council.phone, postal_address: @council.postal_address, postal_suburb_id: @council.postal_suburb_id, state: @council.state, street: @council.street, suburb_id: @council.suburb_id } }
    end

    assert_redirected_to council_url(Council.last)
  end

  test "should show council" do
    get council_url(@council)
    assert_response :success
  end

  test "should get edit" do
    get edit_council_url(@council)
    assert_response :success
  end

  test "should update council" do
    patch council_url(@council), params: { council: { city: @council.city, email: @council.email, fax: @council.fax, name: @council.name, notes: @council.notes, phone: @council.phone, postal_address: @council.postal_address, postal_suburb_id: @council.postal_suburb_id, state: @council.state, street: @council.street, suburb_id: @council.suburb_id } }
    assert_redirected_to council_url(@council)
  end

  test "should destroy council" do
    assert_difference('Council.count', -1) do
      delete council_url(@council)
    end

    assert_redirected_to councils_url
  end
end
