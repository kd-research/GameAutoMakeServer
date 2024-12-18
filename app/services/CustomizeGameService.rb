class CustomizeGameService
  def self.customize_game(params)
    client = OpenAI::Client.new
    response = client.chat(parameters: {
                             model: params.fetch(:model, "gpt-4o"),
                             messages: [
                               { role: "system", content: params[:system_prompt] },
                               { role: "user", content: "```html\n#{params[:game_html]}\n```" },
                               { role: "user", content: params[:request] }
                             ]
                           })
    response.dig("choices", 0, "message", "content")
  end
end
