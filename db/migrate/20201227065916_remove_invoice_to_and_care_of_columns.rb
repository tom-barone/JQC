# frozen_string_literal: true
class RemoveInvoiceToAndCareOfColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :applications, :invoice_to_id, :integer
    remove_column :applications, :care_of_id, :integer
  end
end
