# frozen_string_literal: true
json.extract! suburb, :id, :display_name, :suburb, :state, :postcode, :created_at, :updated_at
json.url suburb_url(suburb, format: :json)
