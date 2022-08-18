class UpdateApplicationsCsvResultsToVersion5 < ActiveRecord::Migration[6.0]
  def change
    update_view :applications_csv_results, version: 5, revert_to_version: 4
  end
end
