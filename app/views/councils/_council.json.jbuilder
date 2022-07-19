# frozen_string_literal: true
json.extract! council, :id, :name, :city, :street, :state, :suburb_id, :postal_address, :postal_suburb_id, :phone, :fax, :email, :notes, :created_at, :updated_at
json.url council_url(council, format: :json)
