# frozen_string_literal: true

class AddAdminColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false

    reversible do |dir|
      dir.up do
        # Make sure our admin user stays an admin
        admin_user = User.where(username: 'admin').first
        admin_user&.update!(admin: true)
      end
    end
  end
end
