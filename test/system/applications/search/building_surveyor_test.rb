# frozen_string_literal: true

require 'application_system_test_case'

class SearchByBuildingSurveyorTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full building surveyor name returns correct result' do
    # Arrange
    create(:pc90_application, building_surveyor: 'John Smith')
    sign_in

    # Act
    search_by(text: 'John Smith')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'John Smith'
    end
  end

  test 'search by partial building surveyor name returns correct result' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Sarah Johnson')
    sign_in

    # Act
    search_by(text: 'Sarah')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Sarah Johnson'
    end
  end

  test 'search by building surveyor last name returns correct result' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Michael Thompson')
    sign_in

    # Act
    search_by(text: 'Thompson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Michael Thompson'
    end
  end

  test 'search by incorrect building surveyor returns no results' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Alice Brown')
    sign_in

    # Act
    search_by(text: 'David Wilson')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search returns multiple applications with same building surveyor' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Emma Davis', reference_number: 'PC100')
    create(:pc91_application, building_surveyor: 'Emma Davis', reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'Emma Davis')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:building_surveyor] do
        assert_text 'Emma Davis'
      end
    end
  end

  test 'search handles applications without building surveyor' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Robert Wilson', reference_number: 'PC100')
    create(:pc91_application, building_surveyor: nil, reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'Robert Wilson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Robert Wilson'
    end
  end

  test 'search distinguishes between different building surveyors' do
    # Arrange
    create(:pc90_application, building_surveyor: 'James Miller', reference_number: 'PC100')
    create(:pc91_application, building_surveyor: 'Jamie Miller', reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'James Miller')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'James Miller'
    end
  end
end
