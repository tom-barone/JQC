# frozen_string_literal: true
class DeleteEmptyClientsAndCouncils < ActiveRecord::Migration[6.0]
  def up
    remove_foreign_key :applications, name: :fk_applicant
    remove_foreign_key :applications, name: :fk_owner
    remove_foreign_key :applications, name: :fk_client
    remove_foreign_key :applications, name: :fk_applicant_council
    remove_foreign_key :applications, name: :fk_client_council
    remove_foreign_key :applications, name: :fk_owner_council
    remove_foreign_key :applications, name: :fk_council

    execute 'SET FOREIGN_KEY_CHECKS = 0'

    add_foreign_key :applications,
                    :clients,
                    column: :applicant_id,
                    name: :fk_applicant,
                    on_delete: :nullify
    add_foreign_key :applications,
                    :clients,
                    column: :owner_id,
                    name: :fk_owner,
                    on_delete: :nullify
    add_foreign_key :applications,
                    :clients,
                    name: :fk_client,
                    on_delete: :nullify
    add_foreign_key :applications,
                    :councils,
                    column: :applicant_council_id,
                    name: :fk_applicant_council,
                    on_delete: :nullify
    add_foreign_key :applications,
                    :councils,
                    column: :client_council_id,
                    name: :fk_client_council,
                    on_delete: :nullify
    add_foreign_key :applications,
                    :councils,
                    column: :owner_council_id,
                    name: :fk_owner_council,
                    on_delete: :nullify
    add_foreign_key :applications,
                    :councils,
                    name: :fk_council,
                    on_delete: :nullify

    execute 'SET FOREIGN_KEY_CHECKS = 1'

    execute 'delete from councils where name is null or name = ""'
    execute 'delete from clients where client_name is null or client_name = ""'
  end
end
