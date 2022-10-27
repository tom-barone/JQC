# frozen_string_literal: true
class ApplicationsCsvResult < ApplicationRecord
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

  scope :filter_all,
        ->(params) {
          filter_by_search_text(params[:search_text])
            .filter_by_type(params[:type])
            .filter_by_date(params[:start_date], params[:end_date])
            # Show PC's first, then Q's
            .order(
              Arel.sql('field (application_type, "PC", "Q", "C", "RC", "LG", "SC") asc, reference_number desc')
            )
        }

  scope :filter_by_type,
        ->(application_type) {
          if application_type != nil
            where(
              "application_type = '#{application_type}'" # Default to PC's
            )
          else
            nil
          end
        }

  scope :filter_by_date,
        ->(start_date, end_date) {
          if start_date != nil or end_date != nil
            where(
              "created_at >= '#{
                start_date ||= '1900-01-01'
              }' and created_at <= '#{end_date ||= DateTime.now}'"
            )
          else
            nil
          end
        }

  scope :filter_by_search_text,
        ->(search_text) {
          return nil if search_text == nil

          result = nil
          search_text.split.each_with_index do |search_word, index|
            if index == 0
              result =
                where(
                  'match(
                      development_application_number,
                      street_name,
                      street_number,
                      lot_number,
                      description
                  ) against (? in boolean mode)
                  or match(suburb) against (? in boolean mode) 
                  or match(contact) against (? in boolean mode) 
                  or match(owner) against (? in boolean mode) 
                  or match(applicant) against (? in boolean mode) 
                  or match(council) against (? in boolean mode) 
                  or reference_number like ?
                  or converted_to_from like ?
                  ',
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  '%' + search_word + '%',
                  '%' + search_word + '%'
                )
            else
              result =
                result.where(
                  'match(
                      development_application_number,
                      street_name,
                      street_number,
                      lot_number,
                      description
                  ) against (? in boolean mode)
                  or match(suburb) against (? in boolean mode) 
                  or match(contact) against (? in boolean mode) 
                  or match(owner) against (? in boolean mode) 
                  or match(applicant) against (? in boolean mode) 
                  or match(council) against (? in boolean mode) 
                  or reference_number like ?
                  or converted_to_from like ?
                  ',
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  search_word,
                  '%' + search_word + '%',
                  '%' + search_word + '%'
                )
            end
          end
          return result
        }

  def self.csv_header
    CSV::Row.new(HEADERS, HEADERS, true)
  end

  def self.find_in_batches(params)
    filter_all(params)
      .find_each(batch_size: 1000) { |application| yield application }
  end
end
