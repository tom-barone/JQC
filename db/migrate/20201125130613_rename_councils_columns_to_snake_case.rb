# frozen_string_literal: true

class RenameCouncilsColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :councils, :CouncilID, :id
    rename_column :councils, :Name, :name
    rename_column :councils, :City, :city
    rename_column :councils, :Street, :street
    rename_column :councils, :State, :state
    rename_column :councils, :SuburbID, :suburb_id
    rename_column :councils, :PostalAddress, :postal_address
    rename_column :councils, :PostalSuburbID, :postal_suburb_id
    rename_column :councils, :Phone, :phone
    rename_column :councils, :Fax, :fax
    rename_column :councils, :Email, :email
    rename_column :councils, :Notes, :notes

  end
end
