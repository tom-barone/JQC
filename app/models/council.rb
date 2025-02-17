# frozen_string_literal: true

class Council < ApplicationRecord
  belongs_to :suburb, optional: true
  belongs_to :postal_suburb, class_name: 'Suburb', optional: true

  has_many :applications, dependent: :nullify
end
