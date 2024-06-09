# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion11 < ActiveRecord::Migration[7.0]
  def change
    update_view :applications_csv_results, version: 11, revert_to_version: 10
  end
end
