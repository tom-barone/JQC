# frozen_string_literal: true

## TODO needs database down migration

class RenameApplicationTypesColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def up

    # Drop all that have a null Application Type
    execute "delete from applications where application_type is null"

    # Remove primary key on the type field
    remove_foreign_key :applications, name: :fk_type
    execute "alter table application_types drop primary key"

    # Add new primary key and rename
    add_column :application_types, :id, :primary_key
    rename_column :application_types, :ApplicationType, :application_type
    rename_column :application_types, :LastUsed, :last_used

    # Add new foreign key column in the applications table
    add_reference :applications, :application_type, foreign_key: true

    # Update all our applications
    execute "update applications a 
      inner join application_types t on a.application_type = t.application_type
      set a.application_type_id = t.id
    "
    remove_column :applications, :application_type, :string

  end
end
