json.extract! incoming_sm, :id, :phone, :content, :request_type, :created_at, :updated_at
json.url incoming_sm_url(incoming_sm, format: :json)
