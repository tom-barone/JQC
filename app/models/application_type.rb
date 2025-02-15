# frozen_string_literal: true

class ApplicationType < ApplicationRecord
  has_many :applications, dependent: :nullify

  # The rough order of importance that these types take. Used in spots like:
  # - Ordering in the applications table
  # - Order in the application type dropdown
  # etc.
  # TODO: This should probably live in the database itself
  NATURAL_ORDER = %w[PC Q C RC LG SC].freeze
end
