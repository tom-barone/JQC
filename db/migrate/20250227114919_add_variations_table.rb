# frozen_string_literal: true

class AddVariationsTable < ActiveRecord::Migration[8.0]
  # rubocop:disable Metrics/BlockLength
  def change
    create_table :variations do |t|
      t.date :variation_date
      t.text :variation_type
      t.date :variation_issued # Migrate from applications.variation_issued

      t.references :application, foreign_key: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # Migrate from the old applications table
        execute <<-SQL.squish
          INSERT INTO variations (
            variation_issued,
            application_id,
            created_at,
            updated_at
          )
          SELECT
            variation_issued,
            id,
            NOW(),
            NOW()
          FROM applications
          WHERE
            variation_issued IS NOT NULL
        SQL

        # Remove the old columns from the applications table
        remove_column :applications, :variation_issued
      end

      dir.down do
        add_column :applications, :variation_issued, :date

        # Migrate data back to Applications table
        execute <<-SQL.squish
          UPDATE applications a
          SET
            variation_issued = v.variation_issued
          FROM variations v
          WHERE a.id = v.application_id
        SQL
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
