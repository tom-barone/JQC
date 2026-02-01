# frozen_string_literal: true

class StructuralEngineer < ApplicationRecord
  belongs_to :application

  STRUCTURAL_ENGINEER = Rails.application.credentials.structural_engineers

  # rubocop:disable Metrics/MethodLength
  def self.report(external_engineer_date_from, external_engineer_date_to)
    ActiveRecord::Base.connection.exec_query(
      "
      SELECT
          a.reference_number,
          a.created_at AS date_entered,
          c.client_name AS applicant,
          a.street_name,
          s.display_name AS suburb,
          a.description,
          a.building_surveyor,
          se.structural_engineer,
          se.external_engineer_date,
          se.structural_engineer_fee,
          se.engineer_certificate_received,
          se.certificate_reference,
          se.structural_engineer_ok_to_pay,
          a.certification_notes
      FROM structural_engineers AS se
      LEFT JOIN applications AS a ON se.application_id = a.id
      LEFT JOIN suburbs AS s ON a.suburb_id = s.id
      LEFT JOIN clients AS c ON a.applicant_id = c.id
      WHERE
          se.external_engineer_date IS NULL
          OR se.external_engineer_date BETWEEN $1 AND $2
        ",
      nil,
      [external_engineer_date_from, external_engineer_date_to]
    )
  end
  # rubocop:enable Metrics/MethodLength
end
