# frozen_string_literal: true

json.extract! application_additional_information, :id, :info_date, :info_text, :application_id, :created_at, :updated_at
json.url application_additional_information_url(application_additional_information, format: :json)
