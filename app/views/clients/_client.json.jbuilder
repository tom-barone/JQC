# frozen_string_literal: true

json.extract! client, :id, :client_type, :client_name, :first_name, :surname, :title, :initials, :salutation,
              :company_name, :street, :suburb_id, :postal_address, :postal_suburb_id, :australian_business_number, :state, :phone, :mobile_number, :fax, :email, :notes, :bad_payer, :created_at, :updated_at
json.url client_url(client, format: :json)
