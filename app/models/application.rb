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
    joins(:application_type)
      .order(Arel.sql(
               "CASE application_types.application_type
         WHEN 'PC' THEN 1
         WHEN 'Q' THEN 2
         WHEN 'C' THEN 3
         WHEN 'RC' THEN 4
         WHEN 'LG' THEN 5
         WHEN 'SC' THEN 6
         ELSE 7 END"
             ))
      .order(reference_number: :desc)
  }

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
end
