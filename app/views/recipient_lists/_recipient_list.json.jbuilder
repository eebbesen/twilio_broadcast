# frozen_string_literal: true

json.extract! recipient_list, :id, :name, :notes, :keyword, :created_at, :updated_at
json.url recipient_list_url(recipient_list, format: :json)
