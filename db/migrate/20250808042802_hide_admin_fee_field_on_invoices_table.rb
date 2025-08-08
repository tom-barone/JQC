# frozen_string_literal: true

class HideAdminFeeFieldOnInvoicesTable < ActiveRecord::Migration[8.0]
  def change
    change_column_comment :invoices, :admin_fee, from: nil, to: 'Currently hidden from the UI'
  end
end
