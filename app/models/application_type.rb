# frozen_string_literal: true

class ApplicationType < ApplicationRecord
  has_many :applications, dependent: :nullify

  def self.ordered_values
    Rails.cache.fetch('application_types_by_display_priority', expires_in: 1.day) do
      order(:display_priority).pluck(:application_type)
    end
  end

  def self.ordered
    order(:display_priority)
  end
end
