# frozen_string_literal: true

class RenameTablesToLowerCaseAndAddTimestamps < ActiveRecord::Migration[6.0]
  def change
    rename_table :AdditionalInfo, :application_additional_information
    rename_table :Applications, :applications
    rename_table :ApplicationTypes, :application_types
    rename_table :Clients, :clients
    rename_table :Councils, :councils
    rename_table :Invoices, :invoices
    rename_table :Stages, :stages
    rename_table :Suburbs, :suburbs
    rename_table :Uploaded, :application_uploads
    add_timestamps(:application_additional_information)
    add_timestamps(:applications)
    add_timestamps(:application_types)
    add_timestamps(:clients)
    add_timestamps(:councils)
    add_timestamps(:invoices)
    add_timestamps(:stages)
    add_timestamps(:suburbs)
    add_timestamps(:application_uploads)
  end
end
