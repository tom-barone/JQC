# frozen_string_literal: true

class Suburb < ApplicationRecord
  has_many :applications, dependent: :nullify

  has_many :clients, dependent: :nullify
  has_many :postal_clients,
           class_name: 'Client',
           inverse_of: :postal_suburb,
           dependent: :nullify

  has_many :councils, dependent: :nullify
  has_many :postal_councils,
           class_name: 'Council',
           inverse_of: :postal_suburb,
           dependent: :nullify

  STATE = %w[SA VIC TAS WA NSW NT ACT QLD].freeze

  scope :search, lambda { |params|
    result = all
    if params[:search_text].present?
      search_term = "%#{params[:search_text]}%"
      result = result.where('suburb ILIKE ? OR postcode ILIKE ?', search_term, search_term)
    end
    result = result.where(state: params[:state]) if params[:state].present?
    result
  }
end
