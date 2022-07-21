# frozen_string_literal: true

require 'application_system_test_case'

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    sign_in_test_user
  end

  test 'Visiting the applications & root page shows the application table' do
    # Test both urls "/applications" and "/" show the applications table
    [applications_url, root_path].each do |url|
      visit url
      assert_text 'Reference Number'
      # Check all the PCs are there
      5.times do |n|
        assert_text "PC#{n}"
      end
      # Check all the LGs are there
      5.times do |n|
        assert_text "LG#{n}"
      end
    end

    # Test searching by application type
    select 'LG', from: 'select_type'
    click_on 'Search'
    5.times do |n|
      assert_no_text "PC#{n}", wait: 10
    end
    5.times do |n|
      assert_text "LG#{n}"
    end
  end
end
