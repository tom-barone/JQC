# frozen_string_literal: true

require 'test_helper'
require 'page_objects/sign_in'
require 'page_objects/nav_bar'
require 'page_objects/applications/edit'
require 'page_objects/applications/search_bar'
require 'page_objects/applications/table'
require 'helpers/application_types'
require 'helpers/navigation'
require 'helpers/cookies'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  Capybara.default_max_wait_time = 5

  include NavigationHelper
  include CookiesHelper
  include ApplicationTypesHelper
end
