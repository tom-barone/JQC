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
end
