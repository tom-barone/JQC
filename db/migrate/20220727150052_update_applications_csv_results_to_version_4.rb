# frozen_string_literal: true

class UpdateApplicationsCsvResultsToVersion4 < ActiveRecord::Migration[6.0]
  def change
    update_view :applications_csv_results, version: 4, revert_to_version: 3
  end
end
