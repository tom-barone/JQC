# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion13 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 13, revert_to_version: 12
  end
end
