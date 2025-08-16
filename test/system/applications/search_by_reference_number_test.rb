# frozen_string_literal: true

require 'application_system_test_case'

class BasicSearchTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by reference number returns correct result' do
    # Arrange
    create(:pc90_application, reference_number: 'PC1001')
    sign_in

    # Act
    search_by(text: 'PC1001')
    results = table_rows_as_hashes

    ## Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC1001'
    end
  end

  test 'search by application reference number prefix returns correct result' do
    # Arrange
    create(:pc90_application, reference_number: 'PC1001')
    sign_in

    # Act
    search_by(text: 'PC1')
    results = table_rows_as_hashes

    # Act & Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC1001'
    end
  end

  test 'search by reference number with numbers only returns correct result' do
    # Arrange
    create(:pc90_application, reference_number: 'PC1001')
    sign_in

    # Act
    search_by(text: '100')
    results = table_rows_as_hashes

    # Act & Assert
    assert_equal 1, results.count
    within results.first[:reference_number] do
      assert_text 'PC1001'
    end
  end

  test 'search by reference number returns no results for non-existent reference' do
    # Arrange
    sign_in

    # Act
    search_by(text: 'PC9999')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search by reference number multiple matching applications returns correct results' do
    # Arrange
    create(:pc90_application, reference_number: 'PC1001')
    create(:pc91_application, reference_number: 'PC1002')
    create(:pc92_application, reference_number: 'PC2002')
    sign_in

    # Act
    search_by(text: 'PC100')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    reference_numbers = results.map { |r| r[:reference_number].text }

    assert_includes reference_numbers, 'PC1001'
    assert_includes reference_numbers, 'PC1002'
  end
end
