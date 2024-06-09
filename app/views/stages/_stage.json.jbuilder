# frozen_string_literal: true

json.extract! stage, :id, :stage_date, :stage_text, :application_id, :created_at, :updated_at
json.url stage_url(stage, format: :json)
