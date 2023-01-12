# frozen_string_literal: true

require 'test_helper'
require 'browser_test_case'

class ApplicationSystemTestCase < BrowserTestCase
  fixtures :all

  def before_teardown
    dump_js_coverage
  end
end
