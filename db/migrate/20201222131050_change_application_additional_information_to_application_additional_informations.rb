# frozen_string_literal: true
class ChangeApplicationAdditionalInformationToApplicationAdditionalInformations < ActiveRecord::Migration[6.0]
  def change
    rename_table :application_additional_information, :application_additional_informations
  end
end
