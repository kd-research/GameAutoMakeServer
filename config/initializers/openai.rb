OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai_api_key
  config.log_errors = Rails.env.production?.!
end
