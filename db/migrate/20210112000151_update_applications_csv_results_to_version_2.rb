# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :applications_csv_results, version: 2, revert_to_version: 1
  end
end
