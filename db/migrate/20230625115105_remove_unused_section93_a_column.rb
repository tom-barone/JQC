# frozen_string_literal: true

class RemoveUnusedSection93AColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :applications, :section_93A, type: :date
  end
end
