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

  has_many :application_uploads, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :application_uploads, allow_destroy: true

  has_many :application_additional_informations, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :application_additional_informations,
                                allow_destroy: true

  has_many :stages, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :stages, allow_destroy: true

  has_many :invoices, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :invoices, allow_destroy: true

  JOB_TYPE_ADMINISTRATION = ['Residential', 'Commercial', 'Section 49']
  BUILDING_SURVEYOR = %w[Vic Ian Peter Darryl Kanchanie Simon Sam Matt]
  STRUCTURAL_ENGINEER = %w[Internal External]
  RISK_RATING = %w[High Medium Low]
  JOB_TYPE = %w[BRC Other]
  CONSENT = %w[Approved Refused]
  CERTIFIER = %w[Vic Peter]

  scope :filter_all,
        ->(params) {
          filter_by_search_text(params[:search_text])
            .filter_by_type(params[:type])
            .filter_by_date(params[:start_date], params[:end_date])
            # Show PC's first, then Q's
            .order(
              'field (application_type_id, 3, 4, 1, 5, 2, 6) asc, reference_number desc'
            )
        }

  scope :filter_by_type,
        ->(application_type) {
          if application_type != nil
            joins(:application_type).where(
              "application_types.application_type = '#{application_type}'" # Default to PC's
            )
          else
            nil
          end
        }

  scope :filter_by_date,
        ->(start_date, end_date) {
          if start_date != nil or end_date != nil
            where(
              "applications.created_at >= '#{
                start_date ||= '1900-01-01'
              }' and applications.created_at <= '#{end_date ||= DateTime.now}'"
            )
          else
            nil
          end
        }

  scope :filter_by_search_text,
        ->(search_text) {
          if search_text != nil
            joins('left join suburbs s on applications.suburb_id = s.id')
              .joins(
                'left join clients contact on applications.client_id = contact.id'
              )
              .joins(
                'left join clients owner on applications.owner_id = owner.id'
              )
              .joins(
                'left join clients applicant on applications.applicant_id = applicant.id'
              )
              .joins('left join councils c on applications.council_id = c.id')
              .where(
                'match(
                  development_application_number,
                  street_name,
                  street_number,
                  lot_number,
                  description
              ) against (? in boolean mode)
              or match(s.display_name) against (? in boolean mode) 
              or match(contact.client_name) against (? in boolean mode) 
              or match(owner.client_name) against (? in boolean mode) 
              or match(applicant.client_name) against (? in boolean mode) 
              or match(c.name) against (? in boolean mode) 
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

  def suburb_display_name=(display_name)
    self.suburb = Suburb.find_by(display_name: display_name)
  end
  def suburb_display_name
    self.suburb ? self.suburb.display_name : nil
  end

  def council_name=(name)
    self.council = Council.find_or_create_by(name: name)
  end
  def council_name
    self.council ? self.council.name : nil
  end

  def applicant_name=(name)
    self.applicant = Client.find_or_create_by(client_name: name)
  end
  def applicant_name
    self.applicant ? self.applicant.client_name : nil
  end
  def owner_name=(name)
    self.owner = Client.find_or_create_by(client_name: name)
  end
  def owner_name
    self.owner ? self.owner.client_name : nil
  end
  def client_name=(name)
    self.client = Client.find_or_create_by(client_name: name)
  end
  def client_name
    self.client ? self.client.client_name : nil
  end
end
