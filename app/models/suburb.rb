# frozen_string_literal: true

class Suburb < ApplicationRecord
  has_many :applications

  STATE = %w[SA VIC TAS WA NSW NT ACT QLD].freeze
end
