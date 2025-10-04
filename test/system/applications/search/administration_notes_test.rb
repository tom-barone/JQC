# frozen_string_literal: true

require 'application_system_test_case'

class SearchByAdministrationNotesTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full administration notes returns correct result' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: 'Payment received via direct transfer on 15/03/2024')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end

  test 'search by partial administration notes returns correct result' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: 'direct transfer')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end

  test 'search by single word from administration notes returns correct result' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: 'payment')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end

  test 'search by multiple words from administration notes returns correct result' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: 'received transfer')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end

  test 'search by incorrect administration notes returns no results' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: 'invoice outstanding')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search is case insensitive' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: 'PAYMENT RECEIVED')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end
end
