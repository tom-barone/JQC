json.extract! application_upload, :id, :uploaded_date, :uploaded_text, :application_id, :created_at, :updated_at
json.url application_upload_url(application_upload, format: :json)
