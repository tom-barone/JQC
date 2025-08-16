# frozen_string_literal: true

require 'application_system_test_case'

class SearchClearButtonTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'clear search after combined criteria shows all applications' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling')
    create(:q90_application, description: 'Commercial office building')
    create(:pc91_application, description: 'Industrial warehouse')
    sign_in

    # Act - Search with combined criteria
    search_by(type: 'PC', text: 'residential dwelling')
    filtered_results = table_rows_as_hashes
    click_clear_search
    click_search
    all_results = table_rows_as_hashes

    # Assert
    assert_equal 1, filtered_results.count
    assert_equal 3, all_results.count
  end

  test 'clear search after date range search shows all applications' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 2, 10))
    create(:pc91_application, created_at: Date.new(2024, 2, 20))
    create(:pc92_application, created_at: Date.new(2024, 3, 5))
    sign_in

    # Act - Search by date range
    search_by(start_date: Date.new(2024, 2, 15), end_date: Date.new(2024, 2, 25))
    filtered_results = table_rows_as_hashes
    click_clear_search
    click_search
    all_results = table_rows_as_hashes

    # Assert
    assert_equal 1, filtered_results.count
    assert_equal 3, all_results.count
  end

  test 'sequential searches with clear in between work correctly' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling')
    create(:q90_application, description: 'Commercial office building')
    create(:pc91_application, description: 'Industrial warehouse')
    sign_in

    # Act - First search
    search_by(type: 'PC')
    first_results = table_rows_as_hashes
    click_clear_search
    search_by(text: 'office building')
    second_results = table_rows_as_hashes
    click_clear_search
    search_by(type: 'Q', text: 'commercial')
    third_results = table_rows_as_hashes

    # Assert
    assert_equal 2, first_results.count
    assert_equal 1, second_results.count
    assert_equal 1, third_results.count
  end

  test 'clear search after all three criteria applied shows all applications' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 7, 10), description: 'New residential dwelling')
    create(:q90_application, created_at: Date.new(2024, 7, 15), description: 'Commercial office building')
    create(:pc91_application, created_at: Date.new(2024, 7, 20), description: 'Industrial warehouse')
    sign_in

    # Act - Search with all three criteria
    search_by(
      type: 'PC',
      text: 'residential dwelling',
      start_date: Date.new(2024, 7, 5),
      end_date: Date.new(2024, 7, 15)
    )
    filtered_results = table_rows_as_hashes
    click_clear_search
    click_search
    all_results = table_rows_as_hashes

    # Assert
    assert_equal 1, filtered_results.count
    assert_equal 3, all_results.count
  end
end
