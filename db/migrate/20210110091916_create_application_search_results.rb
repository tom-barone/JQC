# frozen_string_literal: true

class CreateApplicationSearchResults < ActiveRecord::Migration[6.0]
  def change
    create_view :application_search_results
  end
end
