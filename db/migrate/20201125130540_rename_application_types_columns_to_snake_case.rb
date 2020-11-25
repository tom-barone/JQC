# frozen_string_literal: true

class RenameApplicationTypesColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :application_types, :ApplicationType, :application_type
    rename_column :application_types, :LastUsed, :last_used
  end
end
