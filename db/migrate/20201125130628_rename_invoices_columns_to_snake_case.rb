# frozen_string_literal: true

class RenameInvoicesColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :invoices, :InvoiceId, :invoice_id
    rename_column :invoices, :InvoiceNo, :invoice_number
    rename_column :invoices, :Stage, :stage
    rename_column :invoices, :Fee, :fee
    rename_column :invoices, :GST, :gst
    rename_column :invoices, :DAC, :dac
    rename_column :invoices, :Lodgement, :lodgement
    rename_column :invoices, :InsLevy, :insurance_levy
    rename_column :invoices, :PercentInvoiced, :percent_invoiced
    rename_column :invoices, :InvoiceDate, :invoice_date
    rename_column :invoices, :Paid, :paid
    rename_column :invoices, :ApplicationID, :application_id

  end
end
