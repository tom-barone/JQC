# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion7 < ActiveRecord::Migration[6.0]
  def change
    update_view :applications_csv_results, version: 7, revert_to_version: 6
  end
end
