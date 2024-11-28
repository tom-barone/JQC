# frozen_string_literal: true

class ApplicationType < ApplicationRecord
  validates :last_used, numericality: { only_integer: true }
end
