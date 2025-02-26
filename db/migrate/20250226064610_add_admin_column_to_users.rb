# frozen_string_literal: true

class AddAdminColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
