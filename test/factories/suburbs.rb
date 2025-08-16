# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :suburb do
    suburb { Faker::Address.city }
    state { Suburb::STATE.sample }
    postcode { Faker::Address.zip_code }
  end
end
