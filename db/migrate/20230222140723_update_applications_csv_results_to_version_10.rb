class UpdateApplicationsCsvResultsToVersion10 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 10, revert_to_version: 9
  end
end
