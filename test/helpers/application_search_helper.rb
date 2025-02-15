# frozen_string_literal: true

## frozen_string_literal: true

module ApplicationSearchHelper
  def select_application_type(type)
    select type, from: 'type'
  end

  def click_search
    click_on 'Search'
  end

  def clear_search
    click_on 'clear-search'
  end
end
