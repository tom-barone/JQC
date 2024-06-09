# frozen_string_literal: true

class CreateRequestForInformations < ActiveRecord::Migration[6.0]
  def change
    create_table :request_for_informations do |t|
      t.date :request_for_information_date
      t.integer :application_id, null: false, foreign_key: true

      t.timestamps
    end
    add_foreign_key :request_for_informations,
                    :applications,
                    on_delete: :cascade

    reversible do |dir|
      dir.up do
        # Add all existing RFI dates on applications into the new table
        execute <<~SQL.squish
          INSERT INTO request_for_informations#{' '}
            (application_id, request_for_information_date, created_at, updated_at)
          SELECT#{' '}
            id as application_id,#{' '}
            request_for_information_issued as request_for_information_date,#{' '}
            created_at,
            updated_at
          FROM applications where request_for_information_issued is not null;
        SQL
      end
    end
  end
end
