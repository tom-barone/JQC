# frozen_string_literal: true

#FactoryBot.define do

  #factory :application_type do
    #application_type { 'PC' }
    #last_used { 63_920 }
  #end

  #factory :suburb, aliases: %i[postal_suburb] do
    #sequence(:display_name) { |n| "Suburb display name #{n}" }
    #sequence(:suburb) { |n| "Suburb #{n}" }
    #state { 'SA' }
    #sequence(:postcode) { |n| n }
  #end

  #factory :council,
          #aliases: %i[applicant_council owner_council client_council] do
    #sequence(:name) { |n| "Council name #{n}" }
    #sequence(:city) { |n| "Council city #{n}" }
    #sequence(:street) { |n| "Council street #{n}" }
    #state { 'SA' }
    #suburb
    #sequence(:postal_address) { |n| "Council postal address #{n}" }
    #postal_suburb
    #phone { '1234 5678' }
    #fax { '8765 4321' }
    #sequence(:email) { |n| "council#{n}@email.com" }
    #notes { 'Council notes' }
  #end

  #factory :client, aliases: %i[applicant owner] do
    #client_type { 'Individual' }
    #sequence(:client_name) { |n| "Client name #{n}" }
    #first_name { 'John' }
    #surname { 'Citizen' }
    #title { 'Mr' }
    #initials { 'J.C.' }
    #salutation { '' }
    #company_name { 'Johns Company' }
    #street { 'First street' }
    #suburb
    #sequence(:postal_address) { |n| "Client postal address #{n}" }
    #postal_suburb
    #sequence(:australian_business_number) { |n| "ABN#{n}" }
    #state { 'SA' }
    #phone { '1234 5678' }
    #mobile_number { '0413 345 678' }
    #fax { '8765 4321' }
    #sequence(:email) { |n| "client#{n}@email.com" }
    #notes { 'Client notes' }
    #bad_payer { false }
  #end

  #factory :application do
    #application_type
    #sequence(:reference_number) { |n| "PC#{n}" }
    #converted_to_from { nil }
    #council
    #sequence(:development_application_number) { |n| "DAN#{n}" }
    #applicant
    #applicant_council
    #owner
    #owner_council
    #client
    #client_council
    #description { 'Description' }
    #cancelled { false }

    #sequence(:street_number) { :to_s }
    #sequence(:lot_number) { |n| "L#{n}" }
    #sequence(:street_name) { |n| "Street Name#{n}" }
    #suburb

    #created_at { 5.days.ago }
  #end
#end
