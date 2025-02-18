# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Application < ApplicationRecord
  belongs_to :suburb, optional: true
  belongs_to :council, optional: true

  belongs_to :applicant, class_name: 'Client', optional: true
  belongs_to :owner, class_name: 'Client', optional: true
  belongs_to :contact, class_name: 'Client', optional: true

  belongs_to :application_type

  amoeba { enable }

  # Do the conversions between records and update the last used reference number
  before_create :update_last_used_reference_number
  before_update :convert_to_new_application

  has_many :application_uploads, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :application_uploads, allow_destroy: true

  has_many :application_additional_informations,
           inverse_of: :application,
           dependent: :destroy
  accepts_nested_attributes_for :application_additional_informations,
                                allow_destroy: true

  has_many :request_for_informations,
           inverse_of: :application,
           dependent: :destroy
  accepts_nested_attributes_for :request_for_informations, allow_destroy: true

  has_many :stages, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :stages, allow_destroy: true

  has_many :invoices, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :invoices, allow_destroy: true

  JOB_TYPE_ADMINISTRATION = ['Residential', 'Commercial', 'Section 49'].freeze
  BUILDING_SURVEYOR = Rails.application.credentials.building_surveyors
  STRUCTURAL_ENGINEER = Rails.application.credentials.structural_engineers
  RISK_RATING = %w[High Standard Low].freeze
  JOB_TYPE = %w[BRC Other].freeze
  CONSENT = %w[Approved Refused].freeze

  # Define the getter and setter methods for the client name & suburb fields
  # This is so we can use the client name in the new/edit form
  def suburb_display_name=(display_name)
    self.suburb = Suburb.find_by(display_name:)
  end

  def suburb_display_name
    suburb&.display_name
  end

  def council_name=(name)
    stripped = name.strip
    if stripped == ''
      self.council = nil
      return
    end
    self.council = Council.find_or_create_by(name: stripped)
  end

  def council_name
    council&.name
  end

  %i[applicant owner contact].each do |attribute|
    define_method("#{attribute}_name=") do |name|
      stripped = name.strip
      if stripped.empty?
        send("#{attribute}=", nil)
        return
      end
      send("#{attribute}=", Client.find_or_create_by(client_name: stripped))
    end

    define_method("#{attribute}_name") do
      send(attribute)&.client_name
    end
  end

  scope :filter_by_type, lambda { |type|
    joins(:application_type).where(application_types: { application_type: type }) if type.present?
  }

  scope :filter_by_date, lambda { |start_date, end_date|
    scope = all
    scope = scope.where(applications: { created_at: start_date.. }) if start_date.present?
    scope = scope.where(applications: { created_at: ..end_date }) if end_date.present?
    scope
  }

  scope :order_by_type_and_reference_number, lambda {
    joins(:application_type)
      .order(Arel.sql('application_types.display_priority ASC'))
      .order(reference_number: :desc)
  }

  # See db/migrate/20250215120712_add_text_search_to_applications.rb for the triggers and search functions
  # behind the searchable_tsvector column
  scope :filter_by_search_text, lambda { |query|
    return all if query.blank?

    formatted_query = query.split.map { |word| "#{word}:*" }.join(' & ')
    safe_query = sanitize_sql_array(["searchable_tsvector @@ to_tsquery('english', ?)", formatted_query])

    where(Arel.sql(safe_query))
  }

  # Not used right now, but could be cool in the future
  scope :order_by_search_text_rank, lambda { |query|
    return all if query.blank?

    formatted_query = query.split.map { |word| "#{word}:*" }.join(' & ')
    safe_rank = sanitize_sql_array(["ts_rank(searchable_tsvector, to_tsquery('english', ?)) DESC", formatted_query])

    order(Arel.sql(safe_rank))
  }

  def self.eager_load_associations
    eager_load(:application_type, :applicant, :owner, :contact, :council, :suburb)
  end

  # We need to use `update_column` and skip ActiveRecord validations
  # because otherwise we get into an infinite validation loop
  # rubocop:disable Rails/SkipsModelValidations
  def update_last_used_reference_number
    new_type = ApplicationType.find(application_type_id)
    new_type.update_column('last_used', new_type.last_used + 1)
  end

  def convert_to_new_application
    return unless application_type_id_changed?

    # Create the fields for the old record
    old_record = amoeba_dup
    old_record.save!
    old_record.update_columns(application_type_id: application_type_id_was, reference_number: reference_number_was,
                              converted_to_from: reference_number)

    # Update the fields for the new record
    update_columns(converted_to_from: reference_number_was, updated_at: old_record[:updated_at] + 1.minute)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def converted_application
    return if converted_to_from.blank?

    Application.eager_load_associations.where(reference_number: converted_to_from)
               .first
  end

  def self.search(params)
    Application.eager_load_associations
               .filter_by_type(params[:type])
               .filter_by_date(params[:start_date], params[:end_date])
               .filter_by_search_text(params[:search_text])
               .order_by_type_and_reference_number
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def self.write_csv_response(applications, response)
    # Eager load the associations we need to export
    applications = applications.includes(:request_for_informations).includes(:invoices)

    columns = [
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
      ['staged_consent', ->(app) { app.staged_consent }],
      ['engagement_form', ->(app) { app.engagement_form }],
      ['job_type_administration', ->(app) { app.job_type_administration }],
      ['quote_accepted_date', ->(app) { app.quote_accepted_date }],
      ['administration_notes', ->(app) { app.administration_notes }],
      ['number_of_storeys', ->(app) { app.number_of_storeys }],
      ['construction_value', ->(app) { app.construction_value }],
      ['fee_amount', ->(app) { app.fee_amount }],
      ['building_surveyor', ->(app) { app.building_surveyor }],
      ['structural_engineer', ->(app) { app.structural_engineer }],
      ['external_engineer_date', ->(app) { app.external_engineer_date }],
      ['structural_engineer_fee', ->(app) { app.structural_engineer_fee }],
      ['engineer_certificate_received', ->(app) { app.engineer_certificate_received }],
      ['certificate_reference', ->(app) { app.certificate_reference }],
      ['documented_performance_solutions', ->(app) { app.documented_performance_solutions }],
      ['risk_rating', ->(app) { app.risk_rating }],
      ['consultancies_review_inspection', ->(app) { app.consultancies_review_inspection }],
      ['consultancies_report_sent', ->(app) { app.consultancies_report_sent }],
      ['assessment_commenced', ->(app) { app.assessment_commenced }],
      ['request_for_information_dates', lambda { |app|
        app.request_for_informations.map(&:request_for_information_date).join(', ')
      }],
      ['consent_issued', ->(app) { app.consent_issued }],
      ['variation_issued', ->(app) { app.variation_issued }],
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

    filename = "JQC_Applications_Export_#{Time.zone.now.strftime('%Y-%m-%d')}.csv"

    response.headers.merge!(
      'Content-Type' => 'text/csv',
      'Content-Disposition' => "attachment; filename=\"#{filename}\"",
      'X-Accel-Buffering' => 'no',
      'Cache-Control' => 'no-cache',
      'Last-Modified' => Time.current.httpdate
    )
    response.headers.delete('Content-Length')
    response.stream.write CSV.generate_line(columns.map(&:first))

    applications.find_in_batches(batch_size: 1000) do |batch|
      batch.each do |application|
        response.stream.write CSV.generate_line(
          columns.map { |_, getter| getter.call(application) }
        )
      end
    end
  ensure
    response.stream.close
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
# rubocop:enable Metrics/ClassLength
