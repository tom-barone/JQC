# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :application_type do
    application_type { 'PC' }
    display_priority { 1 }
    active { true }
    last_used { Faker::Number.between(from: 1000, to: 9999) }

    trait :pc do
      application_type { 'PC' }
      display_priority { 1 }
    end

    trait :q do
      application_type { 'Q' }
      display_priority { 2 }
    end

    trait :c do
      application_type { 'C' }
      display_priority { 3 }
    end
  end
end
