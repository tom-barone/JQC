# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    factory :business_client do
      client_type { 'Business' }
    end

    factory :individual_client do
      client_type { 'Individual' }
    end
  end
end

