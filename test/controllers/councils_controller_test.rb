require 'test_helper'

class CouncilsControllerTest < ActionDispatch::IntegrationTest
  setup do
    #sign_in_test_user
    #@council = councils(:council_1)
    #@unused = councils(:unused)
  end

  test "should get index" do
    skip
    get councils_url
    assert_response :success
  end

  test "should get new" do
    skip
    get new_council_url
    assert_response :success
  end

  test "should create council" do
    skip
    assert_difference('Council.count') do
      post councils_url, params: { council: { city: @council.city, email: @council.email, fax: @council.fax, name: @council.name, notes: @council.notes, phone: @council.phone, postal_address: @council.postal_address, postal_suburb_id: @council.postal_suburb_id, state: @council.state, street: @council.street, suburb_id: @council.suburb_id } }
    end

    assert_redirected_to council_url(Council.last)
  end

  test "should show council" do
    skip
    get council_url(@council)
    assert_response :success
  end

  test "should get edit" do
    skip
    get edit_council_url(@council)
    assert_response :success
  end

  test "should update council" do
    skip
    patch council_url(@council), params: { council: { city: @council.city, email: @council.email, fax: @council.fax, name: @council.name, notes: @council.notes, phone: @council.phone, postal_address: @council.postal_address, postal_suburb_id: @council.postal_suburb_id, state: @council.state, street: @council.street, suburb_id: @council.suburb_id } }
    assert_redirected_to council_url(@council)
  end

  test "should destroy council" do
    skip
    assert_difference('Council.count', -1) do
      delete council_url(@unused)
    end

    assert_redirected_to councils_url
  end
end
