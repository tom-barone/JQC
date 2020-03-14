class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :reference_number

      t.timestamps
    end
  end
end
