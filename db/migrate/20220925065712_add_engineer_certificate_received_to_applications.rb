# frozen_string_literal: true

class AddEngineerCertificateReceivedToApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :engineer_certificate_received, :date, after: :certifier
  end
end
