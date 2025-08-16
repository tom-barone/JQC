# frozen_string_literal: true

require 'application_system_test_case'

class SearchByCombinedCriteriaTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  # Combined Search Tests

  test 'search by date range and application type returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 6, 10))
    create(:pc91_application, created_at: Date.new(2024, 6, 15))
    create(:q90_application, created_at: Date.new(2024, 6, 12))
    create(:pc92_application, created_at: Date.new(2024, 6, 20))
    sign_in

    # Act
    search_by(
      type: 'PC',
      start_date: Date.new(2024, 6, 11),
      end_date: Date.new(2024, 6, 18)
    )
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC91'
    end
    within results.first[:date_entered] do
      assert_text '15 Jun 2024'
    end
  end

  test 'search by date range and search text returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 5, 10), description: 'New residential dwelling')
    create(:pc91_application, created_at: Date.new(2024, 5, 15), description: 'Commercial office building')
    create(:pc92_application, created_at: Date.new(2024, 5, 20), description: 'New residential dwelling')
    create(:pc93_application, created_at: Date.new(2024, 5, 25), description: 'Industrial warehouse')
    sign_in

    # Act
    search_by(
      text: 'residential dwelling',
      start_date: Date.new(2024, 5, 12),
      end_date: Date.new(2024, 5, 22)
    )
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling'
    end
    within results.first[:date_entered] do
      assert_text '20 May 2024'
    end
  end

  test 'search by application type and search text returns correct results' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling')
    create(:q90_application, description: 'Structural assessment')
    create(:pc91_application, description: 'Commercial office building')
    create(:q91_application, description: 'New residential dwelling')
    sign_in

    # Act
    search_by(type: 'PC', text: 'residential dwelling')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC90'
    end
    within results.first[:description] do
      assert_text 'New residential dwelling'
    end
  end

  test 'search by all three criteria returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 4, 10), description: 'New residential dwelling')
    create(:pc91_application, created_at: Date.new(2024, 4, 15), description: 'Commercial office building')
    create(:q90_application, created_at: Date.new(2024, 4, 12), description: 'New residential dwelling')
    create(:pc92_application, created_at: Date.new(2024, 4, 20), description: 'New residential dwelling')
    sign_in

    # Act
    search_by(
      type: 'PC',
      text: 'residential dwelling',
      start_date: Date.new(2024, 4, 11),
      end_date: Date.new(2024, 4, 18)
    )
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search by all three criteria with matching data returns correct results' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 3, 10), description: 'New residential dwelling')
    create(:pc91_application, created_at: Date.new(2024, 3, 15), description: 'New residential dwelling')
    create(:q90_application, created_at: Date.new(2024, 3, 12), description: 'New residential dwelling')
    create(:pc92_application, created_at: Date.new(2024, 3, 20), description: 'Commercial office building')
    sign_in

    # Act
    search_by(
      type: 'PC',
      text: 'residential dwelling',
      start_date: Date.new(2024, 3, 11),
      end_date: Date.new(2024, 3, 18)
    )
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC91'
    end
    within results.first[:description] do
      assert_text 'New residential dwelling'
    end
    within results.first[:date_entered] do
      assert_text '15 Mar 2024'
    end
  end

  test 'combined search criteria narrows results appropriately' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling')
    create(:pc91_application, description: 'Commercial office building')
    create(:q90_application, description: 'New residential dwelling')
    sign_in

    # Act - Search by type only
    search_by(type: 'PC')
    type_only_results = table_rows_as_hashes

    # Search by type + text (in a new browser session to avoid state)
    visit applications_path
    search_by(type: 'PC', text: 'residential dwelling')
    combined_results = table_rows_as_hashes

    # Assert
    assert_equal 2, type_only_results.count
    assert_equal 1, combined_results.count
    within combined_results.first[:reference_number] do
      assert_text 'PC90'
    end
  end

  test 'combined search with no matching results returns empty set' do
    # Arrange
    create(:pc90_application, created_at: Date.new(2024, 1, 10), description: 'New residential dwelling')
    create(:q90_application, created_at: Date.new(2024, 1, 15), description: 'Commercial office building')
    sign_in

    # Act
    search_by(
      type: 'PC',
      text: 'warehouse',
      start_date: Date.new(2024, 1, 20),
      end_date: Date.new(2024, 1, 25)
    )
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end
end
