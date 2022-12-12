# frozen_string_literal: true

class ApplicationType < ApplicationRecord
  ALLOWED_TYPES = %w[C LG PC Q RC SC].freeze

  validates :last_used, numericality: { only_integer: true }
end
