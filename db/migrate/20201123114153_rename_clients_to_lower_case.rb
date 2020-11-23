class RenameClientsToLowerCase < ActiveRecord::Migration[6.0]
  def change
    rename_table :Clients, :clients
    add_timestamps(:clients)
  end
end
