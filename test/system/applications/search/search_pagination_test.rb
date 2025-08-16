# frozen_string_literal: true

require 'application_system_test_case'

class SearchPaginationTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'pagination controls are correct when results fit on one page' do
    # Arrange
    pc_type = create(:application_type, application_type: 'PC')
    10.times { |i| create(:application, application_type: pc_type, reference_number: "PC#{1000 + i}") }
    sign_in

    # Act
    visit applications_path

    # Assert
    within PAGINATION_NAV do
      assert_text 1
      assert_no_text 2
    end
  end

  test 'pagination controls are correct when results exceed page limit' do
    # Arrange
    pc_type = create(:application_type, application_type: 'PC')
    510.times { |i| create(:application, application_type: pc_type, reference_number: "PC#{1000 + i}") }
    sign_in

    # Act

    # Assert
    within PAGINATION_NAV do
      assert_text 1
      assert_text 2
      assert_no_text 3
    end
  end

  test 'count of results is correct when results fit on one page' do
    # Arrange
    pc_type = create(:application_type, application_type: 'PC')
    11.times { |i| create(:application, application_type: pc_type, reference_number: "PC#{1000 + i}") }
    sign_in

    # Act

    # Assert
    assert_text '11 results available. Showing 500 results per page.'
  end

  test 'count of results is correct when results exceed page limit' do
    # Arrange
    pc_type = create(:application_type, application_type: 'PC')
    511.times { |i| create(:application, application_type: pc_type, reference_number: "PC#{1000 + i}") }
    sign_in

    # Act

    # Assert
    assert_text '511 results available. Showing 500 results per page.'
  end

  test 'results from first page are not shown on second page' do
    # Arrange
    pc_type = create(:application_type, application_type: 'PC')
    520.times { |i| create(:application, application_type: pc_type, reference_number: "PC#{1000 + i}") }
    sign_in

    # Act & Assert
    assert_text 'PC1510'
    goto_page(2)

    assert_no_text 'PC1510'
  end

  test 'results from second page are not shown on first page' do
    # Arrange
    pc_type = create(:application_type, application_type: 'PC')
    520.times { |i| create(:application, application_type: pc_type, reference_number: "PC#{1000 + i}") }
    sign_in

    # Act & Assert
    assert_no_text 'PC1000'
    goto_page(2)

    assert_text 'PC1000'
  end
end
