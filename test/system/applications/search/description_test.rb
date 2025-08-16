# frozen_string_literal: true

require 'application_system_test_case'

class SearchByDescriptionTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full description returns correct result' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: 'New residential dwelling with attached garage')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end

  test 'search by partial description returns correct result' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: 'residential dwelling')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end

  test 'search by single word from description returns correct result' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: 'garage')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end

  test 'search by multiple words from description returns correct result' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: 'dwelling attached')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end

  test 'search by incorrect description returns no results' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: 'commercial office building')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search is case insensitive' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: 'RESIDENTIAL DWELLING')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end
end
