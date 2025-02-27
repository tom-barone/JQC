# frozen_string_literal: true

class StructuralEngineer < ApplicationRecord
  belongs_to :application

  STRUCTURAL_ENGINEER = Rails.application.credentials.structural_engineers
end
