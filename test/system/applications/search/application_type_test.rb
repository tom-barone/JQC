# frozen_string_literal: true

require 'application_system_test_case'

class SearchByApplicationTypeTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by PC type returns only PC applications' do
    # Arrange
    create(:pc90_application)
    create(:q90_application)
    sign_in

    # Act
    search_by(type: 'PC')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC90'
      assert_no_text 'Q90'
    end
  end

  test 'search by Q type returns only Q applications' do
    # Arrange
    create(:pc90_application)
    create(:q90_application)
    sign_in

    # Act
    search_by(type: 'Q')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'Q90'
      assert_no_text 'PC90'
    end
  end

  test 'search returns multiple applications of same type' do
    # Arrange
    create(:pc90_application)
    create(:pc91_application)
    sign_in

    # Act
    search_by(type: 'PC')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    reference_numbers = results.map { |r| r[:reference_number].text }

    assert_includes reference_numbers, 'PC90'
    assert_includes reference_numbers, 'PC91'
  end

  test 'selecting "Select Type:" shows all application types' do
    # Arrange
    create(:pc90_application)
    create(:q90_application)
    create(:c90_application)
    sign_in

    # Act
    search_by(type: 'Select Type:')
    results = table_rows_as_hashes

    # Assert
    reference_numbers = results.map { |r| r[:reference_number].text }

    assert_includes reference_numbers, 'PC90'
    assert_includes reference_numbers, 'Q90'
    assert_includes reference_numbers, 'C90'
  end
end
