# frozen_string_literal: true

class ApplicationType < ApplicationRecord
  has_many :applications, dependent: :nullify

  ALLOWED_TYPES = %w[C LG PC Q RC SC].freeze
end
