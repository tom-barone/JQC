# frozen_string_literal: true

require 'application_system_test_case'

class SearchByDaNumberAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search handles extra spaces around DA number' do
    # Arrange
    create(:pc90_application, development_application_number: '98765432')
    sign_in

    # Act
    search_by(text: '  98765432  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '98765432'
    end
  end

  test 'search handles complex DA numbers with other characters' do
    # Arrange
    create(:pc90_application, development_application_number: 'DA12/34-56')
    sign_in

    # Act
    search_by(text: 'DA12/34-56')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text 'DA12/34-56'
    end
  end

  test 'search returns multiple applications with exact matching DA numbers' do
    # Arrange
    create(:pc90_application, development_application_number: '20231001')
    create(:pc91_application, development_application_number: '20231001')
    create(:pc92_application, development_application_number: '20241001')
    sign_in

    # Act
    search_by(text: '20231001')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:da_no] do
        assert_text '20231001'
      end
    end
  end

  test 'search distinguishes between similar patterns with different formats' do
    # Arrange
    create(:pc90_application, development_application_number: '12345678')
    create(:pc91_application, development_application_number: '1234-5678')
    sign_in

    # Act
    search_by(text: '1234-5678')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:da_no] do
      assert_text '1234-5678'
    end
  end
end
