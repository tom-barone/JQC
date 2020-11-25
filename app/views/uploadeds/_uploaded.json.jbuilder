json.extract! uploaded, :id, :UploadedDate, :UploadedText, :ApplicationID_id, :created_at, :updated_at
json.url uploaded_url(uploaded, format: :json)
