# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :application do
    association :application_type

    reference_number { "#{application_type.application_type}#{Faker::Number.between(from: 1000, to: 9999)}" }
    description { Faker::Lorem.sentence }
    created_at { Faker::Date.between(from: 2.years.ago, to: Date.current) }

    factory :pc_application do
      association :application_type, :pc
    end
  end
end
