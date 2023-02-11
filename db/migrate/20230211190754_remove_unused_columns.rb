# frozen_string_literal: true

class RemoveUnusedColumns < ActiveRecord::Migration[7.0]
  def up
    change_table :applications, bulk: true do |a|
      a.remove_foreign_key name: :fk_applicant_council
      a.remove_foreign_key name: :fk_owner_council
      a.remove_foreign_key name: :fk_client_council
      a.remove :applicant_council_id
      a.remove :owner_council_id
      a.remove :client_council_id
      a.remove :request_for_information_issued
      a.remove :job_type
      a.remove :consent
      a.remove :certifier
    end
  end
end
