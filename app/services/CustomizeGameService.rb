class CustomizeGameService
  def self.customize_game(params)
    client = OpenAI::Client.new(log_errors: true)
    system_role = case params[:model]
                  when /^o1-.*$/ then "user"
                  else "developer"
                  end

    response = client.chat(parameters: {
                             model: params.fetch(:model, "gpt-4o"),
                             messages: [
                               { role: system_role, content: params[:system_prompt] },
                               { role: "user", content: "```html\n#{params[:game_html]}\n```" },
                               { role: "user", content: params[:request] }
                             ]
                           })
    response.dig("choices", 0, "message", "content")
  end
end
