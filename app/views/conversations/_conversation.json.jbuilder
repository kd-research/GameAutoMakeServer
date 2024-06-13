json.extract! conversation, :id, :system_message, :previous_id, :created_at, :updated_at
json.url conversation_url(conversation, format: :json)
