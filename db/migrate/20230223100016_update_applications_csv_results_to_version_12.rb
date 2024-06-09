# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion12 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 12, revert_to_version: 11
  end
end
