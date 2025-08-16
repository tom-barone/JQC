# frozen_string_literal: true

require 'application_system_test_case'

class SearchByDateEnteredTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search for applications on a specific date returns correct result' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 6, 15))
    create(:pc91_application, created_at: Date.new(2024, 6, 14))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 6, 15), end_date: Date.new(2024, 6, 15))
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:date_entered] do
      assert_text '15 Jun 2024'
    end
  end

  test 'search for applications within a date range returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 5, 10))
    create(:pc91_application, created_at: Date.new(2024, 5, 15))
    create(:pc92_application, created_at: Date.new(2024, 5, 20))
    create(:pc93_application, created_at: Date.new(2024, 5, 25))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 5, 12), end_date: Date.new(2024, 5, 22))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '15 May 2024'
    assert_includes dates, '20 May 2024'
  end

  test 'search for applications after a specific date returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 3, 10))
    create(:pc91_application, created_at: Date.new(2024, 3, 20))
    create(:pc92_application, created_at: Date.new(2024, 3, 30))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 3, 15))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '20 Mar 2024'
    assert_includes dates, '30 Mar 2024'
  end

  test 'search for applications before a specific date returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 8, 5))
    create(:pc91_application, created_at: Date.new(2024, 8, 15))
    create(:pc92_application, created_at: Date.new(2024, 8, 25))
    sign_in

    # Act
    search_by(end_date: Date.new(2024, 8, 20))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '5 Aug 2024'
    assert_includes dates, '15 Aug 2024'
  end

  test 'search returns no results for dates with no applications' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 1, 10))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 12, 1), end_date: Date.new(2024, 12, 31))
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end
end
