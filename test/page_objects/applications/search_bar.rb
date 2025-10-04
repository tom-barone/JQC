# frozen_string_literal: true

module Applications
  module SearchBarPageObject
    # Constants for form elements
    TYPE_SELECT = 'type'
    START_DATE_FIELD = 'start_date'
    END_DATE_FIELD = 'end_date'
    SEARCH_TEXT_FIELD = 'search_text'
    SEARCH_BUTTON = 'Search'
    CLEAR_SEARCH_BUTTON = 'clear-search'

    def select_application_type(type)
      select type, from: TYPE_SELECT
    end

    def fill_search_text(text)
      fill_in SEARCH_TEXT_FIELD, with: text
    end

    def fill_start_date(date)
      fill_in START_DATE_FIELD, with: date
    end

    def fill_end_date(date)
      fill_in END_DATE_FIELD, with: date
    end

    def click_search
      click_on SEARCH_BUTTON
      begin
        # Wait for our search to complete by checking the button state
        find_button(SEARCH_BUTTON, disabled: true, wait: 0.5)
        find_button(SEARCH_BUTTON, disabled: false, wait: 0.5)
      rescue Capybara::ElementNotFound
        # Our search might've finished really quickly, so ignore the errors
      end
    end

    def click_clear_search
      click_on CLEAR_SEARCH_BUTTON
    end

    def search_by(type: nil, text: nil, start_date: nil, end_date: nil)
      select_application_type(type) if type
      fill_search_text(text) if text
      fill_start_date(start_date) if start_date
      fill_end_date(end_date) if end_date
      click_search
    end

    def clear_all_fields
      select 'Select Type:', from: TYPE_SELECT
      fill_search_text('')
      fill_start_date('')
      fill_end_date('')
    end
  end
end
