class UpdateApplicationSearchResultsToVersion5 < ActiveRecord::Migration[7.0]
  def change
    update_view :application_search_results, version: 5, revert_to_version: 4
  end
end
