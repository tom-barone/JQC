# frozen_string_literal: true

class RemoveUnusedInvoiceColumns < ActiveRecord::Migration[7.0]
  # Remove columns "dac", "lodgement", "insurance_levy" from table "application"
  def change
    change_table :invoices, bulk: true do |i|
      i.remove :dac, type: :decimal, precision: 13, scale: 2
      i.remove :lodgement, type: :decimal, precision: 13, scale: 2
      i.remove :insurance_levy, type: :decimal, precision: 13, scale: 2
    end
  end
end
