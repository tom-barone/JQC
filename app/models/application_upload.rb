# frozen_string_literal: true

class ApplicationUpload < ApplicationRecord
  belongs_to :application

  STAGE = ['Approval', 'Stage', 'Variation', 'Regulation 83', 'COO'].freeze
end
