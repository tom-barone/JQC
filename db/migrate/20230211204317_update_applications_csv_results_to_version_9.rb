# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion9 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 9, revert_to_version: 8
  end
end
