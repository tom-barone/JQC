# frozen_string_literal: true

class ApplicationType < ApplicationRecord
  has_many :applications, dependent: :nullify

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:display_priority) }

  def self.active_ordered_values
    # I did cache these at one point, but it was a bit premature
    active.ordered.pluck(:application_type)
  end

  def self.ordered_values
    # I did cache these at one point, but it was a bit premature
    ordered.pluck(:application_type)
  end
end
