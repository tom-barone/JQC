# frozen_string_literal: true

class AddNewFieldsToApplications < ActiveRecord::Migration[8.0]
  def change
    change_table :applications, bulk: true do |t|
      t.boolean :staged_consent, default: false, null: false
      t.decimal :area_m2, precision: 13, scale: 2
      t.boolean :construction_industry_trading_board, default: false, null: false
      t.boolean :kd_to_lodge, default: false, null: false
      t.boolean :variation_requested, default: false, null: false
    end

    add_column :stages, :stage_notes, :text
  end
end
