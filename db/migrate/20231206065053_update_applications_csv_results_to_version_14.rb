# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion14 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 14, revert_to_version: 13
  end
end
