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

  has_many :request_for_informations, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :request_for_informations, allow_destroy: true

  has_many :stages, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :stages, allow_destroy: true

  has_many :invoices, inverse_of: :application, dependent: :destroy
  accepts_nested_attributes_for :invoices, allow_destroy: true

  JOB_TYPE_ADMINISTRATION = ['Residential', 'Commercial', 'Section 49']
  BUILDING_SURVEYOR = %w[Vic Ian Peter Darryl Kanchanie Simon Sam Matt Frank]
  STRUCTURAL_ENGINEER = ['Jack Adcock', 'Triaxial', 'Leo Noicos', 'External', 'Internal']
  RISK_RATING = %w[High Standard Low]
  JOB_TYPE = %w[BRC Other]
  CONSENT = %w[Approved Refused]
  CERTIFIER = %w[Vic Peter]

  before_create :update_last_used_reference_number
  before_update :convert_to_new_application

  def update_last_used_reference_number
    if self.application_type_id_changed?
      new_type = ApplicationType.find_by_id!(self.application_type_id)
      new_type.update_column('last_used', new_type.last_used + 1)
    end
  end

  def convert_to_new_application
    if self.application_type_id_changed?
      # Create the fields for the old record
      old_record = self.amoeba_dup
      old_record.save!
      old_record.update_column(
        'application_type_id',
        self.application_type_id_was
      )
      old_record.update_column('reference_number', self.reference_number_was)
      old_record.update_column('converted_to_from', self.reference_number)

      # Update the fields for the new record
      self.update_column('converted_to_from', self.reference_number_was)
    end
  end

  def suburb_display_name=(display_name)
    self.suburb = Suburb.find_by(display_name: display_name)
  end
  def suburb_display_name
    self.suburb ? self.suburb.display_name : nil
  end

  # TODO refactor this into a function
  def council_name=(name)
    stripped = name.strip
    if stripped == ''
      self.council = nil
      return
    end
    self.council = Council.find_or_create_by(name: stripped)
  end
  def council_name
    self.council ? self.council.name : nil
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
    self.applicant ? self.applicant.client_name : nil
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
    self.owner ? self.owner.client_name : nil
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
    self.client ? self.client.client_name : nil
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
    self.applicant_council ? self.applicant_council.name : nil
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
    self.owner_council ? self.owner_council.name : nil
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
    self.client_council ? self.client_council.name : nil
  end
end
