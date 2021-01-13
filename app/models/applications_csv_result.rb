class ApplicationsCsvResult < ApplicationRecord
  self.primary_key = :id

  scope :filter_all,
        ->(params) {
          filter_by_search_text(params[:search_text])
            .filter_by_type(params[:type])
            .filter_by_date(params[:start_date], params[:end_date])
            # Show PC's first, then Q's
            .order(
              'field (application_type, "PC", "Q", "C", "RC", "LG", "SC") asc, reference_number desc'
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
          if search_text != nil
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
              ',
                search_text,
                search_text,
                search_text,
                search_text,
                search_text,
                search_text,
                '%' + search_text + '%'
              )
          else
            nil
          end
        }

  def self.to_csv
    headers = %w[
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
      fee_amount
      building_surveyor
      structural_engineer
      risk_rating
      assesment_commenced
      request_for_information_issued
      consent_issued
      variation_issued
      coo_issued
      job_type
      consent
      certifier
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
    CSV.generate(headers: true) do |csv|
      csv << headers

      all.find_each(batch_size: 10000) do |a|
        csv << headers.map { |header| a.send(header) }
      end
    end
  end
end