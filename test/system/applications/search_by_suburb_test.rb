# frozen_string_literal: true

require 'application_system_test_case'

class SearchBySuburbTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full suburb name returns correct result' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: 'Adelaide SA 5000')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
  end

  test 'search by full suburb name with comma returns correct result' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: 'Adelaide, SA 5000')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
  end

  test 'search by suburb state returns correct result' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: 'SA')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
  end

  test 'search by suburb postcode returns correct result' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: '5000')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
  end

  test 'search by partial suburb name does not return any results' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: 'Adel')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search by incorrect suburb returns no results' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: 'Melbourne')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search returns multiple applications with same suburb' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb, reference_number: 'PC100')
    create(:pc91_application, suburb: suburb, reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'Adelaide')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:suburb] do
        assert_text 'Adelaide, SA 5000'
      end
    end
  end
end
