# frozen_string_literal: true

class ApplicationsCsvResult < ApplicationRecord
  include Filterable
  self.primary_key = :id

  HEADERS = %w[
    id
    application_type
    reference_number
    converted_to_from
    council
    development_application_number
    applicant
    applicant_council
    owner
    owner_council
    contact
    contact_council
    description
    cancelled
    street_number
    lot_number
    street_name
    suburb
    section_93A
    electronic_lodgement
    hard_copy
    job_type_administration
    quote_accepted_date
    administration_notes
    number_of_storeys
    construction_value
    fee_amount
    building_surveyor
    structural_engineer
    external_engineer_date
    risk_rating
    assessment_commenced
    request_for_information_dates
    consent_issued
    variation_issued
    coo_issued
    job_type
    consent
    certifier
    engineer_certificate_received
    certification_notes
    invoice_to
    care_of
    invoice_email
    attention
    purchase_order_number
    fully_invoiced
    invoice_debtor_notes
    applicant_email
    created_at
    updated_at
  ]

  def self.csv_header
    CSV::Row.new(HEADERS, HEADERS, true)
  end

  def self.find_in_batches(params, &block)
    filter_all(params)
      .find_each(batch_size: 1000, &block)
  end
end
