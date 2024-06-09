# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :applications_csv_results, version: 3, revert_to_version: 2
  end
end
