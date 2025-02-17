# frozen_string_literal: true

class AddDisplayPriorityToApplicationTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :application_types, :display_priority, :integer, default: 0

    # Manually set the display_priority for each application type
    reversible do |dir|
      dir.up do
        ApplicationType.find_by(application_type: 'PC').update!(display_priority: 1)
        ApplicationType.find_by(application_type: 'Q').update!(display_priority: 2)
        ApplicationType.find_by(application_type: 'C').update!(display_priority: 3)
        ApplicationType.find_by(application_type: 'RC').update!(display_priority: 4)
        ApplicationType.find_by(application_type: 'LG').update!(display_priority: 5)
        ApplicationType.find_by(application_type: 'SC').update!(display_priority: 6)
      end
    end
  end
end
