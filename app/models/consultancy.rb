# frozen_string_literal: true

class Consultancy < ApplicationRecord
  belongs_to :application

  TYPE = ['Site Inspection', 'BRC Review', 'Advice'].freeze
end
