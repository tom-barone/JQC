# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion8 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 8, revert_to_version: 7
  end
end
