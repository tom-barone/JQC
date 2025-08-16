# frozen_string_literal: true

require 'application_system_test_case'

class SearchByCouncilAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search is case insensitive' do
    # Arrange
    council = create(:council, name: 'Unley Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'unley council')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Unley Council'
    end
  end

  test 'search handles extra spaces' do
    # Arrange
    council = create(:council, name: 'Holdfast Bay Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: '  Holdfast   Bay   Council  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Holdfast Bay Council'
    end
  end

  test 'search distinguishes between similar council names' do
    # Arrange
    adelaide_city = create(:council, name: 'Adelaide City Council')
    adelaide_hills = create(:council, name: 'Adelaide Hills Council')
    create(:pc90_application, council: adelaide_city)
    create(:pc91_application, council: adelaide_hills)
    sign_in

    # Act
    search_by(text: 'Adelaide Hills Council')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Adelaide Hills Council'
    end
  end

  test 'search handles councils with special characters' do
    # Arrange
    council_apostrophe = create(:council, name: "St John's Council")
    council_hyphen = create(:council, name: 'Tea Tree Gully-North Council')
    create(:pc90_application, council: council_apostrophe)
    create(:pc91_application, council: council_hyphen)
    sign_in

    # Act
    search_by(text: "St John's")
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text "St John's Council"
    end
  end

  test 'search handles councils with different types' do
    # Arrange
    city_council = create(:council, name: 'City of Marion')
    district_council = create(:council, name: 'District Council of Yankalilla')
    create(:pc90_application, council: city_council)
    create(:pc91_application, council: district_council)
    sign_in

    # Act
    search_by(text: 'Marion')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'City of Marion'
    end
  end

  test 'search handles applications with different councils' do
    # Arrange
    council1 = create(:council, name: 'Glenelg Council')
    council2 = create(:council, name: 'Norwood Payneham St Peters Council')
    create(:pc90_application, council: council1)
    create(:pc91_application, council: council2)
    sign_in

    # Act
    search_by(text: 'Norwood')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Norwood Payneham St Peters Council'
    end
  end

  test 'search handles uppercase input' do
    # Arrange
    council = create(:council, name: 'West Torrens Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'WEST TORRENS')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'West Torrens Council'
    end
  end

  test 'search handles mixed case input' do
    # Arrange
    council = create(:council, name: 'Prospect Council')
    create(:pc90_application, council: council)
    sign_in

    # Act
    search_by(text: 'PrOsPeCt CoUnCiL')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:council] do
      assert_text 'Prospect Council'
    end
  end
end
