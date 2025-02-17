# frozen_string_literal: true

require 'application_system_test_case'

class BasicHealthTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit '/'

    assert_selector 'body'
  end
end
