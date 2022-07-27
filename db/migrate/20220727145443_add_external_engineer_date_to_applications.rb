# frozen_string_literal: true

class AddExternalEngineerDateToApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :external_engineer_date, :date
  end
end
