# frozen_string_literal: true

class Application < ApplicationRecord
  belongs_to :suburb, optional: true
  belongs_to :council, optional: true

  belongs_to :applicant, class_name: 'Client', optional: true
  belongs_to :owner, class_name: 'Client', optional: true
  belongs_to :contact, class_name: 'Client', optional: true

  belongs_to :application_type

  amoeba { enable }

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
    # Use the NATURAL_ORDER constant from the ApplicationType model
    # to order the applications by type
    when_clauses = ApplicationType::NATURAL_ORDER.each_with_index.map do |type, index|
      "WHEN '#{type}' THEN #{index}"
    end.join(' ')

    joins(:application_type)
      .order(Arel.sql("CASE application_types.application_type #{when_clauses} ELSE 9 END"))
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

  def self.search(params)
    Application.eager_load(:suburb, :council, :applicant, :application_type)
               .filter_by_type(params[:type])
               .filter_by_date(params[:start_date], params[:end_date])
               .filter_by_search_text(params[:search_text])
               .order_by_type_and_reference_number
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.write_csv_response(applications, response)
    attributes = %w[reference_number description]
    filename = "JQC_Applications_Export_#{Time.zone.now.strftime('%Y-%m-%d')}.csv"

    response.headers.merge!(
      'Content-Type' => 'text/csv',
      'Content-Disposition' => "attachment; filename=\"#{filename}\"",
      'X-Accel-Buffering' => 'no',
      'Cache-Control' => 'no-cache',
      'Last-Modified' => Time.current.httpdate
    )
    response.headers.delete('Content-Length')
    response.stream.write CSV.generate_line(attributes)

    applications.find_in_batches(batch_size: 1000) do |batch|
      batch.each do |application|
        response.stream.write CSV.generate_line(
          attributes.map { |attr| application.send(attr) }
        )
      end
    end
  ensure
    response.stream.close
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
