# frozen_string_literal: true

class UpdateApplicationSearchResultsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :application_search_results, version: 2, revert_to_version: 1
  end
end
