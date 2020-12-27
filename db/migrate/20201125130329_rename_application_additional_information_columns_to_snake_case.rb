# frozen_string_literal: true

class RenameApplicationAdditionalInformationColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :application_additional_information, :InfoId, :id
    rename_column :application_additional_information, :InfoDate, :info_date
    rename_column :application_additional_information, :InfoText, :info_text
    rename_column :application_additional_information, :ApplicationID, :application_id
  end
end
