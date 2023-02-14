# frozen_string_literal: true

class RenameApplicationClientToContact < ActiveRecord::Migration[7.0]
  def change
    rename_column :applications, :client_id, :contact_id
  end
end
