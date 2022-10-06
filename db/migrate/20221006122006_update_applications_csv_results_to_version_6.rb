class UpdateApplicationsCsvResultsToVersion6 < ActiveRecord::Migration[6.0]
  def change
    update_view :applications_csv_results, version: 6, revert_to_version: 5
  end
end
