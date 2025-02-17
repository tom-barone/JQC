# frozen_string_literal: true

require 'application_system_test_case'
require 'helpers/application_search_helper'

class SearchApplicationByTypeTest < ApplicationSystemTestCase
  include ApplicationSearchHelper

  test 'The applications can be searched by application_type correctly' do
    sign_in_test_user

    # Can see all of them to start with
    ApplicationType.ordered_values.each.with_index do |type, index|
      assert_text "#{type}900#{index}"
    end

    # Searching for each type should only show that type
    ApplicationType.ordered_values.each.with_index do |type, index|
      select_application_type type
      click_search

      assert_text "#{type}900#{index}"
      # None of the other types should be visible
      ApplicationType.ordered_values.reject { |t| t == type }.each.with_index do |t, i|
        assert_no_text "#{t}900#{i}"
      end
    end

    # Clearing the search should show all of them again
    clear_search
    click_search
    ApplicationType.ordered_values.each.with_index do |type, index|
      assert_text "#{type}900#{index}"
    end
  end
end
