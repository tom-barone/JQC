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
      post councils_url, params: { council: { City: @council.City, Email: @council.Email, Fax: @council.Fax, Name: @council.Name, Notes: @council.Notes, Phone: @council.Phone, PostalAddress: @council.PostalAddress, PostalSuburbID_id: @council.PostalSuburbID_id, State: @council.State, Street: @council.Street, SuburbID_id: @council.SuburbID_id } }
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
    patch council_url(@council), params: { council: { City: @council.City, Email: @council.Email, Fax: @council.Fax, Name: @council.Name, Notes: @council.Notes, Phone: @council.Phone, PostalAddress: @council.PostalAddress, PostalSuburbID_id: @council.PostalSuburbID_id, State: @council.State, Street: @council.Street, SuburbID_id: @council.SuburbID_id } }
    assert_redirected_to council_url(@council)
  end

  test "should destroy council" do
    assert_difference('Council.count', -1) do
      delete council_url(@council)
    end

    assert_redirected_to councils_url
  end
end
