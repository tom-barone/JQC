# frozen_string_literal: true

# rubocop:disable Style/Documentation

class RenameSuburbsColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :suburbs, :SuburbID, :id
    rename_column :suburbs, :DisplayName, :display_name
    rename_column :suburbs, :Suburb, :suburb
    rename_column :suburbs, :State, :state
    rename_column :suburbs, :Postcode, :postcode
  end
end
