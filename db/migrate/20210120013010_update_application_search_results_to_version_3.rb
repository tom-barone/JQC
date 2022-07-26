# frozen_string_literal: true
class UpdateApplicationSearchResultsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :application_search_results, version: 3, revert_to_version: 2
  end
end
