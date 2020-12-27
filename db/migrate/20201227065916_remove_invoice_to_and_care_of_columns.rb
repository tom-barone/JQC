class RemoveInvoiceToAndCareOfColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :applications, :invoice_to_id, type: :integer
    remove_column :applications, :care_of_id, type: :integer
  end
end
