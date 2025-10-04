# frozen_string_literal: true

require 'application_system_test_case'

class SearchByOwnerTest < ApplicationSystemTestCase
  include Parallelize
  include Applications::SearchBarPageObject
  include Applications::TablePageObject

  test 'search by full owner name returns correct result' do
    # Arrange
    owner = create(:individual_client, client_name: 'John Smith')
    create(:pc90_application, owner: owner)
    sign_in

    # Act
    search_by(text: 'John Smith')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:owner] do
      assert_text 'John Smith'
    end
  end

  test 'search by business owner name returns correct result' do
    # Arrange
    owner = create(:business_client, client_name: 'ABC Construction Pty Ltd')
    create(:pc90_application, owner: owner)
    sign_in

    # Act
    search_by(text: 'ABC Construction Pty Ltd')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:owner] do
      assert_text 'ABC Construction Pty Ltd'
    end
  end

  test 'search by partial owner name returns correct result' do
    # Arrange
    owner = create(:business_client, client_name: 'XYZ Engineering Solutions')
    create(:pc90_application, owner: owner)
    sign_in

    # Act
    search_by(text: 'XYZ Engineering')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:owner] do
      assert_text 'XYZ Engineering Solutions'
    end
  end

  test 'search by incorrect owner returns no results' do
    # Arrange
    owner = create(:individual_client, client_name: 'Jane Doe')
    create(:pc90_application, owner: owner)
    sign_in

    # Act
    search_by(text: 'NonExistent Client')
    results = table_rows_as_hashes

    # Assert
    assert_empty results
  end

  test 'search returns multiple applications with same owner' do
    # Arrange
    owner = create(:individual_client, client_name: 'Mary Johnson')
    create(:pc90_application, owner: owner)
    create(:pc91_application, owner: owner)
    sign_in

    # Act
    search_by(text: 'Mary Johnson')
    results = table_rows_as_hashes

    # Assert
    assert_equal 2, results.count
    results.each do |result|
      within result[:owner] do
        assert_text 'Mary Johnson'
      end
    end
  end

  test 'search handles applications without owners' do
    # Arrange
    owner = create(:individual_client, client_name: 'Peter Brown')
    create(:pc90_application, owner: owner)
    create(:pc91_application, owner: nil)
    sign_in

    # Act
    search_by(text: 'Peter Brown')
    results = table_rows_as_hashes

    # Assert
    assert_equal 1, results.count
    within results.first[:owner] do
      assert_text 'Peter Brown'
    end
  end
end
