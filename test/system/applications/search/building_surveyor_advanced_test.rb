# frozen_string_literal: true

require 'application_system_test_case'

class SearchByBuildingSurveyorAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search is case insensitive' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Jennifer Anderson')
    sign_in

    # Act
    search_by(text: 'jennifer anderson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Jennifer Anderson'
    end
  end

  test 'search handles extra spaces' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Christopher Lee')
    sign_in

    # Act
    search_by(text: '  Christopher   Lee  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Christopher Lee'
    end
  end

  test 'search handles building surveyors with special characters' do
    # Arrange
    create(:pc90_application, building_surveyor: "O'Connor & Associates", reference_number: 'PC100')
    create(:pc91_application, building_surveyor: 'Smith-Johnson Engineering', reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: "O'Connor")
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text "O'Connor & Associates"
    end
  end

  test 'search distinguishes between similar building surveyor names' do
    # Arrange
    create(:pc90_application, building_surveyor: 'David Smith', reference_number: 'PC100')
    create(:pc91_application, building_surveyor: 'David Smith Jr.', reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'David Smith Jr.')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'David Smith Jr.'
    end
  end

  test 'search handles building surveyors with titles and qualifications' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Dr. Elizabeth Taylor BSc, MSc')
    sign_in

    # Act
    search_by(text: 'Dr. Elizabeth Taylor')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Dr. Elizabeth Taylor BSc, MSc'
    end
  end

  test 'search by qualification returns correct result' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Mark Johnson P.Eng')
    sign_in

    # Act
    search_by(text: 'P.Eng')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'Mark Johnson P.Eng'
    end
  end

  test 'search handles company names as building surveyors' do
    # Arrange
    create(:pc90_application, building_surveyor: 'ABC Engineering Consultants Ltd')
    create(:pc91_application, building_surveyor: 'XYZ Structural Engineers Inc')
    sign_in

    # Act
    search_by(text: 'ABC Engineering')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:building_surveyor] do
      assert_text 'ABC Engineering Consultants Ltd'
    end
  end

  test 'search returns multiple applications with building surveyors containing common words' do
    # Arrange
    create(:pc90_application, building_surveyor: 'Johnson Engineering Services', reference_number: 'PC100')
    create(:pc91_application, building_surveyor: 'Robert Johnson', reference_number: 'PC101')
    sign_in

    # Act
    search_by(text: 'Johnson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    building_surveyors = results.map { |result| result[:building_surveyor].text }

    assert_includes building_surveyors, 'Johnson Engineering Services'
    assert_includes building_surveyors, 'Robert Johnson'
  end
end
