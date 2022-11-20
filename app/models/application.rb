# frozen_string_literal: true

class Application < ApplicationRecord
  belongs_to :council, class_name: 'Council', optional: true
  belongs_to :applicant, class_name: 'Client', optional: true
  belongs_to :applicant_council, class_name: 'Council', optional: true
  belongs_to :owner, class_name: 'Client', optional: true
  belongs_to :owner_council, class_name: 'Council', optional: true
  belongs_to :client, class_name: 'Client', optional: true
  belongs_to :client_council, class_name: 'Council', optional: true
  belongs_to :suburb, optional: true
  belongs_to :application_type

  validates :application_type_id, presence: true
  validates :reference_number, presence: true

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
  BUILDING_SURVEYOR = %w[Vic Ian Peter Darryl Kanchanie Simon Sam Matt Frank].freeze
  STRUCTURAL_ENGINEER = [
    'Jack Adcock',
    'Triaxial',
    'Leo Noicos',
    'External',
    'Internal'
  ].freeze
  RISK_RATING = %w[High Standard Low].freeze
  JOB_TYPE = %w[BRC Other].freeze
  CONSENT = %w[Approved Refused].freeze
  CERTIFIER = %w[Vic Peter].freeze

  before_create :update_last_used_reference_number
  before_update :convert_to_new_application

  def update_last_used_reference_number
    return unless application_type_id_changed?

    new_type = ApplicationType.find_by!(id: application_type_id)
    new_type.update_column('last_used', new_type.last_used + 1)
  end

  def convert_to_new_application
    return unless application_type_id_changed?

    # Create the fields for the old record
    old_record = amoeba_dup
    old_record.save!
    old_record.update_column('application_type_id', application_type_id_was)
    old_record.update_column('reference_number', reference_number_was)
    old_record.update_column('converted_to_from', reference_number)

    # Update the fields for the new record
    update_column('converted_to_from', reference_number_was)
  end

  def suburb_display_name=(display_name)
    self.suburb = Suburb.find_by(display_name: display_name)
  end

  def suburb_display_name
    suburb ? suburb.display_name : nil
  end

  # TODO: refactor this into a function
  def council_name=(name)
    stripped = name.strip
    if stripped == ''
      self.council = nil
      return
    end
    self.council = Council.find_or_create_by(name: stripped)
  end

  def council_name
    council ? council.name : nil
  end

  def applicant_name=(name)
    stripped = name.strip
    if stripped == ''
      self.applicant = nil
      return
    end
    self.applicant = Client.find_or_create_by(client_name: stripped)
  end

  def applicant_name
    applicant ? applicant.client_name : nil
  end

  def owner_name=(name)
    stripped = name.strip
    if stripped == ''
      self.owner = nil
      return
    end
    self.owner = Client.find_or_create_by(client_name: stripped)
  end

  def owner_name
    owner ? owner.client_name : nil
  end

  def client_name=(name)
    stripped = name.strip
    if stripped == ''
      self.client = nil
      return
    end
    self.client = Client.find_or_create_by(client_name: stripped)
  end

  def client_name
    client ? client.client_name : nil
  end

  def applicant_council_name=(name)
    stripped = name.strip
    if stripped == ''
      self.applicant_council = nil
      return
    end
    self.applicant_council = Council.find_or_create_by(name: stripped)
  end

  def applicant_council_name
    applicant_council ? applicant_council.name : nil
  end

  def owner_council_name=(name)
    stripped = name.strip
    if stripped == ''
      self.owner_council = nil
      return
    end
    self.owner_council = Council.find_or_create_by(name: stripped)
  end

  def owner_council_name
    owner_council ? owner_council.name : nil
  end

  def client_council_name=(name)
    stripped = name.strip
    if stripped == ''
      self.client_council = nil
      return
    end
    self.client_council = Council.find_or_create_by(name: stripped)
  end

  def client_council_name
    client_council ? client_council.name : nil
  end

  # Emailed reports
  def self.last_3_months_quotes(this_month)
    three_months_ago = (this_month << 3).to_s
    end_of_last_month = this_month - 1
    convert_to_csv(
      ActiveRecord::Base.connection.exec_query(
        "select
              created_at,
              quote_number,
              building_surveyor,
              fee_amount as quote_cost,
              quote_accepted_date,
              case
                  when (converted_to_from REGEXP '^PC.*') = 1 then converted_to_from
              else null end as PC_converted,
              case
                  when (converted_to_from REGEXP '^C.*') = 1 then converted_to_from
              else null end as C_converted
          from (
              select
                  created_at,
                  case
                      when (reference_number REGEXP '^Q.*') = 1 then reference_number
                  else converted_to_from end as quote_number,
                  case
                      when (reference_number REGEXP '^Q.*') = 1 then converted_to_from
                  else reference_number end as converted_to_from,
                  quote_accepted_date,
                  fee_amount,
                  building_surveyor
              from applications
              where
              (reference_number like 'Q%' or converted_to_from like 'Q%') and
              created_at >= '#{three_months_ago}' and created_at <= '#{end_of_last_month}' and
              cancelled is not true
              group by quote_number
          ) as a order by created_at asc"
      )
    )
  end

  def self.overdue_pcs(this_month)
    three_months_ago = (this_month << 3).to_s
    convert_to_csv(
      ActiveRecord::Base.connection.exec_query(
        "select
          a.reference_number,
          a.assessment_commenced as assessment_started,
          a.request_for_information_issued,
          a.consent_issued,
          a.created_at as date_entered,
          a.risk_rating,
          c.client_name,
          a.building_surveyor,
          a.structural_engineer,
          a.job_type_administration as job_type,
          a.description
      from applications a
      left join clients c on c.id = a.applicant_id
      where
          a.reference_number like 'PC%' and
          a.consent_issued is null and
          a.assessment_commenced is not null and
          (
              -- 3 months have passed since assesment and no RFI date
              a.request_for_information_issued is null and a.assessment_commenced <= '#{three_months_ago}' or
              -- 3 months have passed since the RFI date
              a.request_for_information_issued is not null and
              a.request_for_information_issued <= '#{three_months_ago}'
          ) and cancelled is not true
      order by date_entered asc"
      )
    )
  end

  def self.last_month_pcs(this_month)
    last_month_end = this_month - 1 # minus one day to get last day of month
    last_month_start = last_month_end.beginning_of_month
    convert_to_csv(
      ActiveRecord::Base.connection.exec_query(
        "select
          a.reference_number,
          a.consent_issued,
          a.created_at as date_entered,
          a.risk_rating,
          c.client_name,
          a.building_surveyor,
          a.structural_engineer,
          a.job_type_administration as job_type,
          a.assessment_commenced as assessment_started,
          a.consent
      from applications a
      left join clients c on c.id = a.applicant_id
      where a.reference_number like 'PC%' and
      a.consent_issued >= '#{last_month_start}' and a.consent_issued <= '#{last_month_end}'
      order by consent_issued asc"
      )
    )
  end

  def self.pcs_with_invoices_sent_and_consent_not_issued
    convert_to_csv(
      ActiveRecord::Base.connection.exec_query(
        "select
          i.invoice_date,
          a.reference_number,
          c.client_name as applicant,
          a.invoice_email,
          c.email as applicant_email,
          concat(a.lot_number, ' ', a.street_number, ' ', a.street_name, ' ', s.display_name) as street_address,
          a.building_surveyor,
          i.invoice_number,
          i.fee,
          case when i.paid is true then 'yes' else 'no' end as paid
      from invoices as i
      inner join applications as a on a.id = i.application_id
      inner join suburbs as s on a.suburb_id = s.id
      inner join clients as c on a.applicant_id = c.id
      inner join application_types as t on a.application_type_id = t.id
      where
          i.invoice_date is not null and
          i.fee is not null and
          t.application_type = 'pc' and
          a.consent_issued is null and
          i.invoice_date >= '2021-01-01' and
          a.cancelled is not true
      order by invoice_date"
      )
    )
  end

  def self.convert_to_csv(report)
    CSV.generate(headers: true) do |csv|
      csv << report.columns
      report.rows.each { |row| csv << row }
    end
  end
end
