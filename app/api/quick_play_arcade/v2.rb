module QuickPlayArcade
  class V2 < Grape::API
    version %w[v2], using: :path
    format :json

    desc "It will receive game assets and a natural language request to
    modify this game (ui, playing mechanism etc), and it will return a new html
    game that will fulfill this requirement."
    params do
      requires :game_icon, type: File
      requires :game_splash, type: File
      requires :game_bundle, type: File
      requires :request, type: String
    end
    post "/customize_game" do
      # Create a Faraday connection to the Flask game generator service
      conn = Faraday.new(url: "http://#{ENV['FLASK_GAME_HOST'] || 'flask-game-generator:5001'}") do |f|
        f.request :multipart
        f.adapter Faraday.default_adapter
      end

      # Prepare the multipart request
      payload = {}

      # Add the files to the payload
      payload[:game_icon] = Faraday::Multipart::FilePart.new(
        params[:game_icon][:tempfile].path,
        params[:game_icon][:type],
        params[:game_icon][:filename]
      )

      payload[:game_splash] = Faraday::Multipart::FilePart.new(
        params[:game_splash][:tempfile].path,
        params[:game_splash][:type],
        params[:game_splash][:filename]
      )

      payload[:game_bundle] = Faraday::Multipart::FilePart.new(
        params[:game_bundle][:tempfile].path,
        params[:game_bundle][:type],
        params[:game_bundle][:filename]
      )

      # Add the request text
      payload[:request] = params[:request]

      begin
        # Send the request to the Flask service
        response = conn.post("/v1/customize_game", payload)

        # Handle response status errors
        error!({ error: "Service unavailable", details: response.body }, 503) unless response.success?

        # Parse the JSON response
        result = JSON.parse(response.body)

        # Check for required fields
        required_fields = %w[suggested_name modified_bundle modified_icon modified_splash status message]
        missing_fields = required_fields.select { |field| result[field].nil? }

        if missing_fields.any?
          error!({ error: "Invalid response format", missing_fields: }, 500)
        end

        # Check for required nested fields
        file_fields = %w[modified_bundle modified_icon modified_splash]
        missing_nested_fields = []

        file_fields.each do |field|
          missing_nested_fields << "#{field}.base64Data" unless result[field].is_a?(Hash) && result[field]["base64Data"]
        end

        if missing_nested_fields.any?
          error!({ error: "Invalid response format", missing_fields: missing_nested_fields }, 500)
        end

        # Reorganize the response as required
        {
          suggested_name: result["suggested_name"],
          bundle_base64_data: result["modified_bundle"]["base64Data"],
          icon_base64_data: result["modified_icon"]["base64Data"],
          splash_base64_data: result["modified_splash"]["base64Data"],
          status: result["status"],
          message: result["message"]
        }
      rescue Faraday::Error => e
        error!({ error: "Connection error", details: e.message }, 500)
      rescue JSON::ParserError => e
        error!({ error: "Invalid JSON response", details: e.message }, 500)
      rescue StandardError => e
        error!({ error: "Unexpected error", details: e.message }, 500)
      end
    end

    desc "It will generate a game based on a natural language description."
    params do
      requires :request, type: String, desc: "Text description of the game to generate"
    end
    post "/generate_game" do
      # Create a Faraday connection to the Flask game generator service
      conn = Faraday.new(url: "http://#{ENV['FLASK_GAME_HOST'] || 'flask-game-generator:5001'}") do |f|
        f.request :json
        f.response :json
        f.adapter Faraday.default_adapter
      end

      # Prepare the JSON request
      payload = {
        request: params[:request]
      }

      begin
        # Send the request to the Flask service
        response = conn.post("/v1/generate_game", payload)

        # Handle HTTP errors
        error!({ error: "Service unavailable", details: response.body }, 503) unless response.success?

        # Parse the JSON response
        result = response.body
        if result.is_a?(String)
          result = JSON.parse(result)
        end

        # Check for required fields
        required_fields = %w[suggested_name generated_bundle generated_icon generated_splash status message generation_id]
        missing_fields = required_fields.select { |field| result[field].nil? }

        if missing_fields.any?
          error!({ error: "Invalid response format", missing_fields: }, 500)
        end

        # Check for required nested fields
        file_fields = %w[generated_bundle generated_icon generated_splash]
        missing_nested_fields = []

        file_fields.each do |field|
          missing_nested_fields << "#{field}.base64Data" unless result[field].is_a?(Hash) && result[field]["base64Data"]
        end

        if missing_nested_fields.any?
          error!({ error: "Invalid response format", missing_fields: missing_nested_fields }, 500)
        end

        # Reorganize the response to match the customize_game format
        {
          suggested_name: result["suggested_name"],
          bundle_base64_data: result["generated_bundle"]["base64Data"],
          icon_base64_data: result["generated_icon"]["base64Data"],
          splash_base64_data: result["generated_splash"]["base64Data"],
          status: result["status"],
          message: result["message"],
          generation_id: result["generation_id"]
        }
      rescue Faraday::Error => e
        error!({ error: "Connection error", details: e.message }, 500)
      rescue JSON::ParserError => e
        error!({ error: "Invalid JSON response", details: e.message }, 500)
      rescue StandardError => e
        error!({ error: "Unexpected error", details: e.message }, 500)
      end
    end
  end
end
