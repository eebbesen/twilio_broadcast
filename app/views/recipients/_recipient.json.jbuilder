json.extract! recipient, :id, :phone, :email, :name, :notes, :created_at, :updated_at
json.url recipient_url(recipient, format: :json)
