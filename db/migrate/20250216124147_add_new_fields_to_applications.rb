# frozen_string_literal: true

class AddNewFieldsToApplications < ActiveRecord::Migration[8.0]
  def change
    change_table :applications, bulk: true do |t|
      t.boolean :staged_consent, default: false, null: false
      t.decimal :structural_engineer_fee, precision: 13, scale: 2
      t.integer :documented_performance_solutions
      t.text :certificate_reference
    end
  end
end
