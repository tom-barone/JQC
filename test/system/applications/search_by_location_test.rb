# frozen_string_literal: true

require 'application_system_test_case'

class SearchByLocationTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full address returns correct result' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '5 123 Main Street')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '5 123 Main Street'
    end
  end

  test 'search by lot number returns correct result' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '5')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '5 123 Main Street'
    end
  end

  test 'search by street number returns correct result' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '123')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '123 Main Street'
    end
  end

  test 'search by street name returns correct result' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: 'Main Street')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '123 Main Street'
    end
  end

  test 'search by incorrect address returns no results' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: '456 Elm Street')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search by partial street name returns correct result' do
    # Arrange
    create(:pc90_application, lot_number: '5', street_number: '123', street_name: 'Main Street')
    sign_in

    # Act
    search_by(text: 'Main')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:location] do
      assert_text '123 Main Street'
    end
  end
end
