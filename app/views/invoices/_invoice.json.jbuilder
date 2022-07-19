# frozen_string_literal: true
json.extract! invoice, :id, :invoice_number, :stage, :fee, :gst, :admin_fee, :dac, :lodgement, :insurance_levy, :percent_invoiced, :invoice_date, :paid, :application_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
