# frozen_string_literal: true

class AddStructuralEngineerNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :structural_engineers, :structural_engineer_notes, :text
  end
end
