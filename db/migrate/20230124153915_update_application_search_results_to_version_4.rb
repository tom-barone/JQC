# frozen_string_literal: true

class UpdateApplicationSearchResultsToVersion4 < ActiveRecord::Migration[7.0]
  def change
    update_view :application_search_results, version: 4, revert_to_version: 3
  end
end
