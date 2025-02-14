# frozen_string_literal: true

class ApplicationUpload < ApplicationRecord
  belongs_to :application

  STAGE = %w[Approval Stage Variation COO].freeze
end
