# frozen_string_literal: true

class AddStructuralEngineersTable < ActiveRecord::Migration[8.0]
  # rubocop:disable Metrics/AbcSize, Metrics/BlockLength
  def change
    create_table :structural_engineers do |t|
      t.text :structural_engineer # Migrate from applications.structural_engineer
      t.date :external_engineer_date # Migrate from applications.external_engineer_date
      t.decimal :structural_engineer_fee, precision: 13, scale: 2
      t.date :engineer_certificate_received # Migrate from applications.engineer_certificate_received
      t.text :certificate_reference
      t.boolean :structural_engineer_ok_to_pay, default: false, null: false

      t.references :application, foreign_key: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # Migrate from the old applications table
        execute <<-SQL.squish
          INSERT INTO structural_engineers (
            structural_engineer,
            external_engineer_date,
            engineer_certificate_received,
            application_id,
            created_at,
            updated_at
          )
          SELECT
            structural_engineer,
            external_engineer_date,
            engineer_certificate_received,
            id,
            NOW(),
            NOW()
          FROM applications
          WHERE
            (structural_engineer IS NOT NULL AND structural_engineer != '')  OR
            external_engineer_date IS NOT NULL OR
            engineer_certificate_received IS NOT NULL
        SQL

        # Remove the old columns from the applications table
        remove_column :applications, :structural_engineer
        remove_column :applications, :external_engineer_date
        remove_column :applications, :engineer_certificate_received
      end

      dir.down do
        add_column :applications, :structural_engineer, :text
        add_column :applications, :external_engineer_date, :date
        add_column :applications, :engineer_certificate_received, :date

        # Migrate data back to Applications table
        execute <<-SQL.squish
          UPDATE applications a
          SET
            structural_engineer = se.structural_engineer,
            external_engineer_date = se.external_engineer_date,
            engineer_certificate_received = se.engineer_certificate_received
          FROM structural_engineers se
          WHERE a.id = se.application_id
        SQL
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/BlockLength
end
