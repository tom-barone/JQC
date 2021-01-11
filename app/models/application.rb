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

  def applicant_council_name=(name)
    self.applicant_council = Council.find_or_create_by(name: name)
  end
  def applicant_council_name
    self.applicant_council ? self.applicant_council.name : nil
  end
  def owner_council_name=(name)
    self.owner_council = Council.find_or_create_by(name: name)
  end
  def owner_council_name
    self.owner_council ? self.owner_council.name : nil
  end
  def client_council_name=(name)
    self.client_council = Council.find_or_create_by(name: name)
  end
  def client_council_name
    self.client_council ? self.client_council.name : nil
  end

end
