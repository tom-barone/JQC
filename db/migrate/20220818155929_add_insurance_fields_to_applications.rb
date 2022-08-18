class AddInsuranceFieldsToApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :number_of_storeys, :integer, :after => :administration_notes
    add_column :applications, :construction_value, :decimal, precision: 13, scale: 2,  :after => :number_of_storeys
  end
end
