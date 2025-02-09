# frozen_string_literal: true

class PutCertifierColumnBackInApplications < ActiveRecord::Migration[7.0]
  def up
    # First add the column
    change_table :applications, bulk: true do |a|
      a.text :certifier, after: :coo_issued
    end

    # Direct update from backup
    execute <<-SQL.squish
      UPDATE applications a
      INNER JOIN BACKUP_2022_07_24.applications b ON a.id = b.id
      SET a.certifier = b.certifier
      WHERE b.certifier IS NOT NULL
    SQL
  end

  def down
    remove_column :applications, :certifier
  end
end
