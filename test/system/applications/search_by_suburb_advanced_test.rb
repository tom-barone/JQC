# frozen_string_literal: true

require 'application_system_test_case'

class SearchBySuburbAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search is case insensitive' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: 'adelaide')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
  end

  test 'search handles extra spaces' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb)
    sign_in

    # Act
    search_by(text: '  Adelaide   SA   5000  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
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

  test 'search distinguishes between suburbs with similar names' do
    # Arrange
    adelaide = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    adelaide_hills = create(:suburb, suburb: 'Adelaide Hills', state: 'SA', postcode: '5152')
    create(:pc90_application, suburb: adelaide, reference_number: 'PC100')
    create(:pc91_application, suburb: adelaide_hills, reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'Adelaide Hills')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide Hills, SA 5152'
    end
  end

  test 'search handles suburbs with special characters' do
    # Arrange
    suburb_apostrophe = create(:suburb, suburb: "O'Halloran Hill", state: 'SA', postcode: '5158')
    suburb_hyphen = create(:suburb, suburb: 'Port Adelaide-Enfield', state: 'SA', postcode: '5015')
    create(:pc90_application, suburb: suburb_apostrophe, reference_number: 'PC100')
    create(:pc91_application, suburb: suburb_hyphen, reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: "O'Halloran")
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text "O'Halloran Hill, SA 5158"
    end
  end

  test 'search suburbs across different states' do
    # Arrange
    adelaide_sa = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    richmond_vic = create(:suburb, suburb: 'Richmond', state: 'VIC', postcode: '3121')
    create(:pc90_application, suburb: adelaide_sa, reference_number: 'PC100')
    create(:pc91_application, suburb: richmond_vic, reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'VIC')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Richmond, VIC 3121'
    end
  end

  test 'search handles applications without suburbs' do
    # Arrange
    suburb = create(:suburb, suburb: 'Adelaide', state: 'SA', postcode: '5000')
    create(:pc90_application, suburb: suburb, reference_number: 'PC100')
    create(:pc91_application, suburb: nil, reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'Adelaide')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:suburb] do
      assert_text 'Adelaide, SA 5000'
    end
  end
end
