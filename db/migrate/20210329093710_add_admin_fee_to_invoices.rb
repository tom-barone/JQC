# frozen_string_literal: true
class AddAdminFeeToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :admin_fee, :decimal, precision: 13, scale: 2,  :after => :gst
  end
end
