# frozen_string_literal: true

require 'application_system_test_case'

class SearchByApplicantAdvancedTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search is case insensitive' do
    # Arrange
    applicant = create(:individual_client, client_name: 'Sarah Wilson')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'sarah wilson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Sarah Wilson'
    end
  end

  test 'search handles extra spaces' do
    # Arrange
    applicant = create(:business_client, client_name: 'Global Tech Solutions')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: '  Global   Tech   Solutions  ')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Global Tech Solutions'
    end
  end

  test 'search distinguishes between similar applicant names' do
    # Arrange
    smith_john = create(:individual_client, client_name: 'John Smith')
    smith_jane = create(:individual_client, client_name: 'Jane Smith')
    create(:pc90_application, applicant: smith_john)
    create(:pc91_application, applicant: smith_jane)
    sign_in

    # Act
    search_by(text: 'Jane Smith')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Jane Smith'
    end
  end

  test 'search handles applicants with special characters' do
    # Arrange
    applicant_apostrophe = create(:individual_client, client_name: "O'Connor Building Services")
    applicant_hyphen = create(:business_client, client_name: 'Smith-Jones Construction')
    create(:pc90_application, applicant: applicant_apostrophe)
    create(:pc91_application, applicant: applicant_hyphen)
    sign_in

    # Act
    search_by(text: "O'Connor")
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text "O'Connor Building Services"
    end
  end

  test 'search handles both individual and business client types' do
    # Arrange
    individual = create(:individual_client, client_name: 'Michael Davis')
    business = create(:business_client, client_name: 'Davis Enterprises Pty Ltd')
    create(:pc90_application, applicant: individual)
    create(:pc91_application, applicant: business)
    sign_in

    # Act
    search_by(text: 'Davis')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    applicant_names = results.map { |result| result[:applicant].text }

    assert_includes applicant_names, 'Michael Davis'
    assert_includes applicant_names, 'Davis Enterprises Pty Ltd'
  end

  test 'search handles applications with different applicants' do
    # Arrange
    applicant1 = create(:individual_client, client_name: 'Robert Taylor')
    applicant2 = create(:business_client, client_name: 'Innovative Designs Ltd')
    create(:pc90_application, applicant: applicant1)
    create(:pc91_application, applicant: applicant2)
    sign_in

    # Act
    search_by(text: 'Innovative')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Innovative Designs Ltd'
    end
  end

  test 'search handles uppercase input' do
    # Arrange
    applicant = create(:business_client, client_name: 'Premier Building Group')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'PREMIER BUILDING')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Premier Building Group'
    end
  end

  test 'search handles mixed case input' do
    # Arrange
    applicant = create(:individual_client, client_name: 'Amanda Thompson')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'AmAnDa ThOmPsOn')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Amanda Thompson'
    end
  end
end

