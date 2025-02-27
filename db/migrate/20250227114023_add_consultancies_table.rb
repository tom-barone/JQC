# frozen_string_literal: true

class AddConsultanciesTable < ActiveRecord::Migration[8.0]
  # rubocop:disable Metrics/AbcSize, Metrics/BlockLength
  def change
    create_table :consultancies do |t|
      t.text :consultancy_type
      t.date :scheduled_date # Migrate from applications.consultancies_review_inspection
      t.text :notes
      t.date :report_or_email_sent # Migrate from applications.consultancies_report_sent

      t.references :application, foreign_key: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # Migrate from the old applications table
        execute <<-SQL.squish
          INSERT INTO consultancies (
            scheduled_date,
            report_or_email_sent,
            application_id,
            created_at,
            updated_at
          )
          SELECT
            consultancies_review_inspection,
            consultancies_report_sent,
            id,
            NOW(),
            NOW()
          FROM applications
          WHERE
            consultancies_review_inspection IS NOT NULL OR
            consultancies_report_sent IS NOT NULL
        SQL

        # Remove the old columns from the applications table
        remove_column :applications, :consultancies_review_inspection
        remove_column :applications, :consultancies_report_sent
      end

      dir.down do
        add_column :applications, :consultancies_review_inspection, :date
        add_column :applications, :consultancies_report_sent, :date

        # Migrate data back to Applications table
        execute <<-SQL.squish
          UPDATE applications a
          SET
            consultancies_review_inspection = c.scheduled_date,
            consultancies_report_sent = c.report_or_email_sent
          FROM consultancies c
          WHERE a.id = c.application_id
        SQL
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/BlockLength
end
