# frozen_string_literal: true

require 'application_system_test_case'

class SearchByDescriptionAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search returns multiple matching descriptions' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with garage')
    create(:pc91_application, description: 'Residential extension and garage renovation')
    create(:pc92_application, description: 'Commercial office building construction')
    sign_in

    # Act
    search_by(text: 'residential')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    descriptions = results.map { |r| r[:description].text }

    assert_includes descriptions, 'New residential dwelling with garage'
    assert_includes descriptions, 'Residential extension and garage renovation'
  end

  test 'search handles extra spaces' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    sign_in

    # Act
    search_by(text: '  residential   dwelling  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end

  test 'search handles special characters and punctuation' do
    # Arrange
    create(:pc90_application, description: 'Single-storey dwelling, pool & landscaping')
    create(:pc91_application, description: 'Two-storey home (with deck)')
    sign_in

    # Act
    search_by(text: 'single-storey')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'Single-storey dwelling, pool & landscaping'
    end
  end

  test 'search with mixed terms from description' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling with attached garage')
    create(:pc91_application, description: 'Commercial garage and office space')
    sign_in

    # Act
    search_by(text: 'residential garage')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling with attached garage'
    end
  end

  test 'search distinguishes between similar descriptions' do
    # Arrange
    create(:pc90_application, description: 'New residential dwelling')
    create(:pc91_application, description: 'Residential dwelling extension')
    sign_in

    # Act
    search_by(text: 'new residential')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling'
    end
  end

  test 'search handles applications with empty descriptions' do
    # Arrange
    create(:pc90_application, description: '')
    create(:pc91_application, description: 'New residential dwelling')
    sign_in

    # Act
    search_by(text: 'residential')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling'
    end
  end

  test 'search handles applications with nil descriptions' do
    # Arrange
    create(:pc90_application, description: nil)
    create(:pc91_application, description: 'New residential dwelling')
    sign_in

    # Act
    search_by(text: 'residential')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'New residential dwelling'
    end
  end

  test 'search handles very long descriptions' do
    # Arrange
    long_description = 'Construction of a new three-storey residential dwelling with basement level parking, ' \
                       'ground floor kitchen, dining and living areas, first floor bedrooms and bathrooms, ' \
                       'second floor master suite with ensuite and walk-in robe, rooftop deck with outdoor ' \
                       'kitchen facilities, solar panel installation, rainwater harvesting system, and ' \
                       'landscaped garden with native plantings and irrigation system'
    create(:pc90_application, description: long_description)
    sign_in

    # Act
    search_by(text: 'rooftop deck')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:description] do
      assert_text 'Construction of a new three-storey residential dwelling'
    end
  end
end
