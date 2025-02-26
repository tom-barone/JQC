# frozen_string_literal: true

class AddAreaFieldToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :area_m2, :decimal, precision: 13, scale: 2
  end
end
