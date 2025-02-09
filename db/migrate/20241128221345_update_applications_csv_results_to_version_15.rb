# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion15 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 15, revert_to_version: 14
  end
end
