# frozen_string_literal: true

require 'application_system_test_case'

class SearchByCouncilTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full council name returns correct result' do
    # Arrange
    council = create(:council, name: 'Adelaide City Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'Adelaide City Council')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Adelaide City Council'
    end
  end

  test 'search by partial council name returns correct result' do
    # Arrange
    council = create(:council, name: 'Port Adelaide Enfield Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'Port Adelaide')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Port Adelaide Enfield Council'
    end
  end

  test 'search by council abbreviation returns correct result' do
    # Arrange
    council = create(:council, name: 'City of Charles Sturt')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'Charles Sturt')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'City of Charles Sturt'
    end
  end

  test 'search by incorrect council returns no results' do
    # Arrange
    council = create(:council, name: 'Adelaide Hills Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'NonExistent Council')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search returns multiple applications with same council' do
    # Arrange
    council = create(:council, name: 'Burnside Council')
    create(:pc90_application, council: council)
    create(:pc91_application, council: council)
    sign_in

    # Act
    search_by(text: 'Burnside Council')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:council] do
        assert_text 'Burnside Council'
      end
    end
  end

  test 'search handles applications without councils' do
    # Arrange
    council = create(:council, name: 'Mitcham Council')
    create(:pc90_application, council: council)
    create(:pc91_application, council: nil)
    sign_in

    # Act
    search_by(text: 'Mitcham Council')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Mitcham Council'
    end
  end
end
