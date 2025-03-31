# frozen_string_literal: true

module CsvExportable
  extend ActiveSupport::Concern

  class_methods do
    def write_csv_response(applications, response)
      CsvExporter.new(applications, response).export
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/BlockLength
  included do
    def self.csv_columns
      [
        ['id', ->(app) { app.id }],
        ['application_type', ->(app) { app.application_type&.application_type }],
        ['reference_number', ->(app) { app.reference_number }],
        ['converted_to_from', ->(app) { app.converted_to_from }],
        ['council', ->(app) { app.council&.name }],
        ['development_application_number', ->(app) { app.development_application_number }],
        ['applicant', ->(app) { app.applicant&.client_name }],
        ['owner', ->(app) { app.owner&.client_name }],
        ['contact', ->(app) { app.contact&.client_name }],
        ['description', ->(app) { app.description }],
        ['cancelled', ->(app) { app.cancelled }],
        ['street_number', ->(app) { app.street_number }],
        ['lot_number', ->(app) { app.lot_number }],
        ['street_name', ->(app) { app.street_name }],
        ['suburb', ->(app) { app.suburb&.suburb }],
        ['kd_to_lodge', ->(app) { app.kd_to_lodge }],
        ['staged_consent', ->(app) { app.staged_consent }],
        ['engagement_form', ->(app) { app.engagement_form }],
        ['job_type_administration', ->(app) { app.job_type_administration }],
        ['quote_accepted_date', ->(app) { app.quote_accepted_date }],
        ['administration_notes', ->(app) { app.administration_notes }],
        ['number_of_storeys', ->(app) { app.number_of_storeys }],
        ['construction_value', ->(app) { app.construction_value }],
        ['fee_amount', ->(app) { app.fee_amount }],
        ['area_m²', ->(app) { app.area_m2 }],
        ['building_surveyor', ->(app) { app.building_surveyor }],
        ['risk_rating', ->(app) { app.risk_rating }],
        ['CITB', ->(app) { app.construction_industry_trading_board }],
        ['assessment_commenced', ->(app) { app.assessment_commenced }],
        ['request_for_information_dates', lambda { |app|
          app.request_for_informations.map(&:request_for_information_date).join(', ')
        }],
        ['consent_issued', ->(app) { app.consent_issued }],
        ['variation_requested', ->(app) { app.variation_requested }],
        ['structural_engineers', lambda { |app|
          app.structural_engineers.map(&:structural_engineer).join(', ')
        }],
        ['certificates_received', lambda { |app|
          app.structural_engineers.map(&:engineer_certificate_received).join(', ')
        }],
        ['coo_issued', ->(app) { app.coo_issued }],
        ['certification_notes', ->(app) { app.certification_notes }],
        ['invoice_to', ->(app) { app.invoice_to }],
        ['invoice_email', ->(app) { app.invoice_email }],
        ['invoice_numbers', ->(app) { app.invoices.map(&:invoice_number).join(', ') }],
        ['fully_invoiced', ->(app) { app.fully_invoiced }],
        ['applicant_email', ->(app) { app.applicant_email }],
        ['created_at', ->(app) { app.created_at }],
        ['updated_at', ->(app) { app.updated_at }]
      ]
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/BlockLength

  class CsvExporter
    def initialize(applications, response)
      # Preload associations to avoid N+1 queries
      @applications = applications.includes(:request_for_informations, :invoices)
      @response = response
    end

    def export
      set_response_headers
      write_headers
      write_records
    ensure
      @response.stream.close
    end

    private

    def set_response_headers
      filename = "JQC_Applications_Export_#{Time.zone.now.strftime('%Y-%m-%d')}.csv"

      @response.headers.merge!(
        'Content-Type' => 'text/csv',
        'Content-Disposition' => "attachment; filename=\"#{filename}\"",
        'X-Accel-Buffering' => 'no',
        'Cache-Control' => 'no-cache',
        'Last-Modified' => Time.current.httpdate
      )
      @response.headers.delete('Content-Length')
    end

    def write_headers
      @response.stream.write CSV.generate_line(Application.csv_columns.map(&:first))
    end

    def write_records
      @applications.find_in_batches(batch_size: 1000) do |batch|
        batch.each do |application|
          @response.stream.write CSV.generate_line(
            Application.csv_columns.map { |_, getter| getter.call(application) }
          )
        end
      end
    end
  end
end
