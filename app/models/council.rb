# frozen_string_literal: true

class Council < ApplicationRecord
  belongs_to :suburb, optional: true
  belongs_to :postal_suburb, class_name: 'Suburb', optional: true

  has_many :applications, dependent: :nullify

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
end
