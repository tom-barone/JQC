# frozen_string_literal: true

class RenameClientsColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :clients, :ClientID, :id
    rename_column :clients, :ClientType, :client_type
    rename_column :clients, :ClientName, :client_name
    rename_column :clients, :FirstName, :first_name
    rename_column :clients, :Surname, :surname
    rename_column :clients, :Title, :title
    rename_column :clients, :Initials, :initials
    rename_column :clients, :Salutation, :salutation
    rename_column :clients, :CompanyName, :company_name
    rename_column :clients, :Street, :street
    rename_column :clients, :SuburbID, :suburb_id
    rename_column :clients, :PostalAddress, :postal_address
    rename_column :clients, :PostalSuburbID, :postal_suburb_id
    rename_column :clients, :ABN, :australian_business_number
    rename_column :clients, :State, :state
    rename_column :clients, :Phone, :phone
    rename_column :clients, :MobileNo, :mobile_number
    rename_column :clients, :Fax, :fax
    rename_column :clients, :Email, :email
    rename_column :clients, :Notes, :notes
    rename_column :clients, :BadPayer, :bad_payer

  end
end
