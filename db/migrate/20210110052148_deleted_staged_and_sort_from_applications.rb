class DeletedStagedAndSortFromApplications < ActiveRecord::Migration[6.0]
  def change
    remove_column :applications, :staged, :string
    remove_column :applications, :sort_priority_gen, :integer
    remove_column :invoices, :percent_invoiced, :decimal
  end
end
