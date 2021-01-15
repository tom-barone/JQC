class Client < ApplicationRecord
  belongs_to :suburb, optional: true
  belongs_to :postal_suburb, :class_name => 'Suburb', optional: true

  has_many :applications, dependent: :nullify

  TYPE = %w[Business Individual]

  def suburb_display_name=(display_name)
    self.suburb = Suburb.find_by(display_name: display_name)
  end
  def suburb_display_name
    self.suburb ? self.suburb.display_name : nil
  end

  def postal_suburb_display_name=(display_name)
    self.postal_suburb = Suburb.find_by(display_name: display_name)
  end
  def postal_suburb_display_name
    self.postal_suburb ? self.postal_suburb.display_name : nil
  end
end
