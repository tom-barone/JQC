# frozen_string_literal: true

require 'application_system_test_case'

class SearchByLocationAdvancedTest < ApplicationSystemTestCase
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search returns multiple matching locations' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    create(:pc90_application, lot_number: '7', street_number: '125', street_name: 'Main Street')
    create(:pc90_application, lot_number: '10', street_number: '200', street_name: 'Oak Street')
    sign_in

    # Act
    search_by(text: 'Main Street')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    locations = results.map { |r| r[:location].text }

    assert_includes locations, '5 123 Main Street'
    assert_includes locations, '7 125 Main Street'
  end

  test 'search is case insensitive' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: 'main street')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '5 123 Main Street'
    end
  end

  test 'search handles extra spaces' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '  123   Main   Street  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '5 123 Main Street'
    end
  end

  test 'search by combined partial location elements returns correct result' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    create(:pc90_application, lot_number: '7', street_number: '456', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '123 Main')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '5 123 Main Street'
    end
  end

  test 'search distinguishes between different addresses on same street' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    create(:pc90_application, lot_number: '7', street_number: '125', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '123')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '5 123 Main Street'
    end
  end

  test 'search handles applications without lot numbers' do
    # Arrange
    create(:pc90_application, lot_number: nil, street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '123 Main Street')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '123 Main Street'
    end
  end

  test 'search handles special characters in street names' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: "O'Connor Street")
    create(:pc90_application, lot_number: '7', street_number: '456', street_name: 'King-William Road')
    sign_in

    # Act
    search_by(text: "O'Connor")
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text "5 123 O'Connor Street"
    end
  end
end
