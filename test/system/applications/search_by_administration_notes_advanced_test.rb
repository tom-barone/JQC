# frozen_string_literal: true

require 'application_system_test_case'

class SearchByAdministrationNotesAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search returns multiple matching administration notes' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received for initial fee')
    create(:pc91_application, administration_notes: 'Final payment outstanding, invoice sent')
    create(:pc92_application, administration_notes: 'Application approved without conditions')
    sign_in

    # Act
    search_by(text: 'payment')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    admin_notes = results.map { |r| r[:admin_notes].text }

    assert_includes admin_notes, 'Payment received for initial fee'
    assert_includes admin_notes, 'Final payment outstanding, invoice sent'
  end

  test 'search handles extra spaces' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    sign_in

    # Act
    search_by(text: '  payment   received  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end

  test 'search handles special characters and punctuation' do
    # Arrange
    create(:pc90_application, administration_notes: 'Fee: $2,500 - paid in full (bank transfer)')
    create(:pc91_application, administration_notes: 'Invoice #123-ABC sent via email')
    sign_in

    # Act
    search_by(text: '$2,500')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Fee: $2,500 - paid in full (bank transfer)'
    end
  end

  test 'search with mixed terms from administration notes' do
    # Arrange
    create(:pc90_application, administration_notes: 'Payment received via direct transfer on 15/03/2024')
    create(:pc91_application, administration_notes: 'Direct debit setup for ongoing fees')
    sign_in

    # Act
    search_by(text: 'payment direct')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received via direct transfer on 15/03/2024'
    end
  end

  test 'search distinguishes between similar administration notes' do
    # Arrange
    create(:pc90_application, administration_notes: 'Initial payment received')
    create(:pc91_application, administration_notes: 'Payment received in full')
    sign_in

    # Act
    search_by(text: 'initial payment')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Initial payment received'
    end
  end

  test 'search handles applications with empty administration notes' do
    # Arrange
    create(:pc90_application, administration_notes: '')
    create(:pc91_application, administration_notes: 'Payment received')
    sign_in

    # Act
    search_by(text: 'payment')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received'
    end
  end

  test 'search handles applications with nil administration notes' do
    # Arrange
    create(:pc90_application, administration_notes: nil)
    create(:pc91_application, administration_notes: 'Payment received')
    sign_in

    # Act
    search_by(text: 'payment')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Payment received'
    end
  end

  test 'search handles very long administration notes' do
    # Arrange
    long_notes = 'Initial fee payment of $2,500 received via bank transfer on 15/03/2024. ' \
                 'Application documents reviewed and found to be complete. Structural engineer ' \
                 'reports approved by council. Site inspection scheduled for 25/03/2024. ' \
                 'Building surveyor has confirmed compliance with all relevant codes. ' \
                 'Final approval pending completion of outstanding administrative requirements.'
    create(:pc90_application, administration_notes: long_notes)
    sign_in

    # Act
    search_by(text: 'site inspection')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:admin_notes] do
      assert_text 'Initial fee payment of $2,500 received via bank transfer'
    end
  end
end