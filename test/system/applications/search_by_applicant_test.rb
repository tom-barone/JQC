# frozen_string_literal: true

require 'application_system_test_case'

class SearchByApplicantTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full applicant name returns correct result' do
    # Arrange
    applicant = create(:individual_client, client_name: 'John Smith')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'John Smith')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'John Smith'
    end
  end

  test 'search by business applicant name returns correct result' do
    # Arrange
    applicant = create(:business_client, client_name: 'ABC Construction Pty Ltd')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'ABC Construction Pty Ltd')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'ABC Construction Pty Ltd'
    end
  end

  test 'search by partial applicant name returns correct result' do
    # Arrange
    applicant = create(:business_client, client_name: 'XYZ Engineering Solutions')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'XYZ Engineering')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'XYZ Engineering Solutions'
    end
  end

  test 'search by incorrect applicant returns no results' do
    # Arrange
    applicant = create(:individual_client, client_name: 'Jane Doe')
    create(:pc90_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'NonExistent Client')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search returns multiple applications with same applicant' do
    # Arrange
    applicant = create(:individual_client, client_name: 'Mary Johnson')
    create(:pc90_application, applicant: applicant)
    create(:pc91_application, applicant: applicant)
    sign_in

    # Act
    search_by(text: 'Mary Johnson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:applicant] do
        assert_text 'Mary Johnson'
      end
    end
  end

  test 'search handles applications without applicants' do
    # Arrange
    applicant = create(:individual_client, client_name: 'Peter Brown')
    create(:pc90_application, applicant: applicant)
    create(:pc91_application, applicant: nil)
    sign_in

    # Act
    search_by(text: 'Peter Brown')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:applicant] do
      assert_text 'Peter Brown'
    end
  end
end
