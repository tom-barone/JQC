# frozen_string_literal: true

class AddActiveColumnToApplicationTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :application_types, :active, :boolean, default: true, null: false

    # Manually set the display_priority for each application type
    reversible do |dir|
      dir.up do
        ApplicationType.find_by(application_type: 'LG').update!(active: false)
        ApplicationType.find_by(application_type: 'RC').update!(active: false)
      end
    end
  end
end
