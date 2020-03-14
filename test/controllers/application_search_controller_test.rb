require 'test_helper'

class ApplicationSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get application_search_index_url
    assert_response :success
  end

end
