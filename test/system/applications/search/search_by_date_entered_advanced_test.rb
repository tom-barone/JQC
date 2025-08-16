# frozen_string_literal: true

require 'application_system_test_case'

class SearchByDateEnteredAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search handles very wide date ranges spanning years' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2021, 6, 15))
    create(:pc91_application, created_at: Date.new(2022, 8, 20))
    create(:pc92_application, created_at: Date.new(2023, 10, 10))
    create(:pc93_application, created_at: Date.new(2024, 2, 5))
    sign_in

    # Act
    search_by(start_date: Date.new(2022, 1, 1), end_date: Date.new(2023, 12, 31))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '20 Aug 2022'
    assert_includes dates, '10 Oct 2023'
  end

  test 'search handles leap year dates correctly' do
    # Arrange
    leap_year_date = Date.new(2024, 2, 29)
    create(:pc90_application, created_at: leap_year_date)
    create(:pc91_application, created_at: Date.new(2024, 2, 28))
    create(:pc92_application, created_at: Date.new(2024, 3, 1))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 2, 29), end_date: Date.new(2024, 2, 29))
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:date_entered] do
      assert_text '29 Feb 2024'
    end
  end

  test 'search handles month boundary conditions' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 1, 31))
    create(:pc91_application, created_at: Date.new(2024, 2, 1))
    create(:pc92_application, created_at: Date.new(2024, 2, 28))
    create(:pc93_application, created_at: Date.new(2024, 3, 1))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 2, 1), end_date: Date.new(2024, 2, 28))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '1 Feb 2024'
    assert_includes dates, '28 Feb 2024'
  end

  test 'search handles year boundary conditions' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 12, 31))
    create(:pc91_application, created_at: Date.new(2025, 1, 1))
    create(:pc92_application, created_at: Date.new(2023, 12, 31))
    create(:pc93_application, created_at: Date.new(2024, 1, 1))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 1, 1), end_date: Date.new(2024, 12, 31))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '31 Dec 2024'
    assert_includes dates, '1 Jan 2024'
  end

  test 'search with very narrow date range excludes nearby dates' do
    # Arrange
    target_date = Date.new(2024, 11, 15)
    create(:pc90_application, created_at: target_date - 1.day)
    create(:pc91_application, created_at: target_date)
    create(:pc92_application, created_at: target_date + 1.day)
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 11, 15), end_date: Date.new(2024, 11, 15))
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:date_entered] do
      assert_text '15 Nov 2024'
    end
  end

  test 'search with overlapping date ranges returns correct applications' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 6, 5))
    create(:pc91_application, created_at: Date.new(2024, 6, 10))
    create(:pc92_application, created_at: Date.new(2024, 6, 15))
    create(:pc93_application, created_at: Date.new(2024, 6, 20))
    sign_in

    # Act
    search_by(start_date: Date.new(2024, 6, 8), end_date: Date.new(2024, 6, 17))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '10 Jun 2024'
    assert_includes dates, '15 Jun 2024'
  end

  test 'search handles historical dates from previous years' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2020, 3, 15))
    create(:pc91_application, created_at: Date.new(2021, 7, 22))
    create(:pc92_application, created_at: Date.new(2022, 11, 8))
    sign_in

    # Act
    search_by(start_date: Date.new(2020, 1, 1), end_date: Date.new(2021, 12, 31))
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    dates = results.map { |result| result[:date_entered].text }

    assert_includes dates, '15 Mar 2020'
    assert_includes dates, '22 Jul 2021'
  end
end
