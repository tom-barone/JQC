# frozen_string_literal: true

require 'date'

class SetApplicationCreatedAndUpdatedAtValues < ActiveRecord::Migration[6.0]
  def up
    # Make sure no null values exist
    Application.where(date_entered: nil).update_all(date_entered: Date.new(1901, 1, 1))

    change_column :applications, :date_entered, :datetime, null: false
    Application.update_all('created_at=date_entered')
    Application.update_all('updated_at=created_at')
    remove_column :applications, :date_entered
  end

  def down
    add_column :applications, :date_entered, :datetime
    Application.update_all('date_entered=created_at')
    change_column :applications, :date_entered, :date
    add_index :applications, :date_entered
  end
end
