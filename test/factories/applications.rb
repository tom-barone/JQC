# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :application do
    application_type

    reference_number { "#{application_type.application_type}#{Faker::Number.between(from: 1000, to: 9999)}" }
    created_at { Faker::Date.between(from: 2.years.ago, to: Date.current) }

    # Reload after creation to ensure PostgreSQL triggers populate searchable_tsvector
    after(:create, &:reload)

    factory :pc_application do
      application_type factory: %i[application_type pc]
    end

    # Good for when we need to know the reference number so there's no testing overlap if we use 90 as a street
    # address or something.
    # Use like this:
    #   create(:pc90_application, ...)
    #   create(:pc91_application, ...)
    (0..9).each do |n|
      factory :"pc9#{n}_application" do
        application_type factory: %i[application_type pc]
        reference_number { "PC9#{n}" }
      end
    end
  end
end
