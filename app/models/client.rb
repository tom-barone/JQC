# frozen_string_literal: true

class Client < ApplicationRecord
  belongs_to :suburb, optional: true
  belongs_to :postal_suburb, class_name: 'Suburb', optional: true

  has_many :applicant_applications,
           class_name: 'Application',
           inverse_of: :applicant,
           dependent: :nullify
  has_many :owner_applications,
           class_name: 'Application',
           inverse_of: :owner,
           dependent: :nullify
  has_many :contact_applications,
           class_name: 'Application',
           inverse_of: :contact,
           dependent: :nullify

  TYPE = %w[Business Individual].freeze

  def suburb_display_name=(display_name)
    self.suburb = Suburb.find_by(display_name:)
  end

  def suburb_display_name
    suburb&.display_name
  end

  def postal_suburb_display_name=(display_name)
    self.postal_suburb = Suburb.find_by(display_name:)
  end

  def postal_suburb_display_name
    postal_suburb&.display_name
  end

  def self.eager_load_associations
    eager_load(:suburb, :postal_suburb)
  end
end
