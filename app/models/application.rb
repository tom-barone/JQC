# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Application < ApplicationRecord
  include CsvExportable

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
  CERTIFIER = Rails.application.credentials.certifiers
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
    define_method(:"#{attribute}_name=") do |name|
      stripped = name.strip
      if stripped.empty?
        send(:"#{attribute}=", nil)
        return
      end
      send(:"#{attribute}=", Client.find_or_create_by(client_name: stripped))
    end

    define_method(:"#{attribute}_name") do
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

  scope :filter_by_building_surveyor, lambda { |surveyor|
    where(building_surveyor: surveyor) if surveyor.present?
  }

  scope :filter_by_has_rfis_issued, lambda { |checkbox_value|
    return all unless checkbox_value == '1'

    where.not(request_for_informations: { request_for_information_date: nil })
  }

  scope :filter_by_has_additional_information, lambda { |checkbox_value|
    return all unless checkbox_value == '1'

    where.not(application_additional_informations: { info_date: nil })
  }

  scope :filter_by_has_received_engineer_certificate, lambda { |checkbox_value|
    return all unless checkbox_value == '1'

    where.not(engineer_certificate_received: nil)
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

  scope :with_latest_rfis, lambda {
    latest_rfi_subquery = RequestForInformation
                          .select('DISTINCT ON (application_id) application_id, request_for_information_date')
                          .where.not(request_for_information_date: nil)
                          .order('application_id, request_for_information_date DESC')

    select('applications.*, latest_rfis.*')
      .includes(:request_for_informations)
      .joins("LEFT JOIN (#{latest_rfi_subquery.to_sql}) latest_rfis ON latest_rfis.application_id = applications.id")
  }

  scope :with_latest_additional_informations, lambda {
    latest_additional_information_subquery = ApplicationAdditionalInformation
                                             .select('DISTINCT ON (application_id) application_id, info_date')
                                             .where.not(info_date: nil)
                                             .order('application_id, info_date DESC')

    select('applications.*, latest_additional_informations.*')
      .includes(:application_additional_informations)
      .joins("LEFT JOIN (#{latest_additional_information_subquery.to_sql}) \
             latest_additional_informations ON latest_additional_informations.application_id = applications.id")
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
    eager_load_associations
      .filter_by_type(params[:type])
      .filter_by_date(params[:start_date], params[:end_date])
      .filter_by_search_text(params[:search_text])
      .order_by_type_and_reference_number
  end

  def self.building_surveyor_search(params)
    eager_load_associations
      .filter_by_type(params[:type])
      .filter_by_date(params[:start_date], params[:end_date])
      .filter_by_search_text(params[:search_text])
      .filter_by_building_surveyor(params[:building_surveyor])
      .filter_by_has_rfis_issued(params[:has_rfis_issued])
      .filter_by_has_additional_information(params[:has_additional_information])
      .filter_by_has_received_engineer_certificate(params[:has_received_engineer_certificate])
      .order_by_type_and_reference_number
  end

  def certifier_options
    if CERTIFIER.include?(certifier)
      CERTIFIER
    else
      # This is for old records that may have a certifier that is no longer in the list
      [certifier] + CERTIFIER
    end
  end

  def selected_certifier
    return certifier unless new_record?

    # Select the first option if there is only one, otherwise return nil
    options = certifier_options.compact_blank
    options.length == 1 ? options.first : nil
  end
end
# rubocop:enable Metrics/ClassLength
