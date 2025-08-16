# frozen_string_literal: true

require 'application_system_test_case'

class SearchByDaNumberTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by exact DA number returns correct result' do
    # Arrange
    create(:pc90_application, development_application_number: '12345678')
    sign_in

    # Act
    search_by(text: '12345678')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '12345678'
    end
  end

  test 'search by different DA number returns correct result' do
    # Arrange
    create(:pc90_application, development_application_number: '87654321')
    sign_in

    # Act
    search_by(text: '87654321')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '87654321'
    end
  end

  test 'search by another DA number returns correct result' do
    # Arrange
    create(:pc90_application, development_application_number: '11223344')
    sign_in

    # Act
    search_by(text: '11223344')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '11223344'
    end
  end

  test 'search by incorrect DA number returns no results' do
    # Arrange
    create(:pc90_application, development_application_number: '55667788')
    sign_in

    # Act
    search_by(text: '99887766')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search returns multiple applications with same DA number' do
    # Arrange
    create(:pc90_application, development_application_number: '99112233')
    create(:pc91_application, development_application_number: '99112233')
    sign_in

    # Act
    search_by(text: '99112233')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:da_no] do
        assert_text '99112233'
      end
    end
  end

  test 'search handles applications without DA number' do
    # Arrange
    create(:pc90_application, development_application_number: '44556677')
    create(:pc91_application, development_application_number: nil)
    sign_in

    # Act
    search_by(text: '44556677')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '44556677'
    end
  end

  test 'search distinguishes between different DA numbers' do
    # Arrange
    create(:pc90_application, development_application_number: '12121212')
    create(:pc91_application, development_application_number: '21212121')
    sign_in

    # Act
    search_by(text: '12121212')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '12121212'
    end
  end

  test 'search by partial DA number returns no results' do
    # Arrange
    create(:pc90_application, development_application_number: '13579246')
    sign_in

    # Act
    search_by(text: '13579')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end
end
