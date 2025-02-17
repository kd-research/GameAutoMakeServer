class CustomizeGameService
  class OpenAIChatClient
    def initialize(model: "o3-mini")
      @client = OpenAI::Client.new(log_errors: true, request_timeout: 360)
      @model = model
      @messages = []
    end

    def chat!
      messagesum = @messages.map { |m| m[:content] }.join
      message_hash = Digest::SHA256.hexdigest(messagesum)
      Rails.cache.fetch("openai-chat-#{message_hash}", expires_in: 1.hour) do
        @client.chat(parameters: { model: @model, messages: })
      end
    end

    def add_message(role:, content:)
      @messages << { role:, content: }
    end

    private

    def messages
      o1_mini_message_rectify
    end

    def o1_mini_message_rectify
      # o1-mini lack support for "developer" role, convert to "user"
      return @messages unless /^o1-mini.*$/.match?(@model)

      @messages.map! do |m|
        m[:role] = "user" if m[:role] == "developer"
        m
      end
    end
  end

  include PromptLoadable

  def initialize(model: "o3-mini")
    @model = model
  end

  def game_design_document_reconstruction(html, new_concept, orig_doc: "None")
    client = OpenAIChatClient.new(model: @model)

    user_message = <<~USERMSG
      ### Original Game Design Document
      #{orig_doc}
      ### Proposed Game Concept
      #{new_concept}
      ### Game Dev File
      ```html
      #{html}
      ```
    USERMSG
    client.add_message role: "developer", content: load_prompt("game-design-document-reconstruction")
    client.add_message role: "user", content: user_message

    response = client.chat!
    content = response.dig("choices", 0, "message", "content")
    pattern = /
    ORIG-DOC-BEGIN\s*(?<orig_doc>.*?)\s*ORIG-DOC-END
    \s*
      SUGGEST-GAME-NAME-BEGIN\s*(?<suggested_name>.*?)\s*SUGGEST-GAME-NAME-END
      \s*
      MOD-DOC-BEGIN\s*(?<modified_doc>.*?)\s*MOD-DOC-END
      /mx

    matches = content.match(pattern)

    raise "Failed to extract data from response" if matches.nil?

    suggested_name = matches[:suggested_name]
    orig_doc = matches[:orig_doc]
    modified_doc = matches[:modified_doc]

    { orig_doc:, suggested_name:, modified_doc:, raw: response }
  end

  def html5_game_modification_export(html, modification)
    client = OpenAIChatClient.new(model: @model)
    user_message = <<~USERMSG
      ### Original Game Dev File
      ```html
      #{html}
      ```
      ### Proposed Modification
      #{modification}
    USERMSG

    client.add_message role: "developer", content: load_prompt("html5-game-modification-exporter")
    client.add_message role: "user", content: user_message

    response = client.chat!
    content = response.dig("choices", 0, "message", "content")

    if (matches = content.match(encapsuled_pattern(:html_content_export)))
      { success: true, html: matches[1], raw: response }
    elsif (matches = content.match(encapsuled_pattern(:html_mod_failure_reason)))
      { success: false, reason: matches[1], raw: response }
    else
      raise "Failed to extract data from response"
    end
  end

  def theme_design_generate(mod_game_doc)
    client = OpenAIChatClient.new(model: @model)
    user_message = <<~USERMSG
      ### Modified Game Design Document
      #{mod_game_doc}
    USERMSG

    client.add_message role: "developer", content: load_prompt("theme-design-generator")
    client.add_message role: "user", content: user_message

    response = client.chat!
    content = response.dig("choices", 0, "message", "content")
    matches = content.match(encapsuled_pattern(:theme_doc))

    { theme_design: matches[1], raw: response }
  end

  def game_icon_prompt_generate(theme_doc)
    client = OpenAIChatClient.new(model: @model)
    user_message = <<~USERMSG
      ### Theme Design Document
      #{theme_doc}
    USERMSG

    client.add_message role: "developer", content: load_prompt("game-icon-prompt-generator")
    client.add_message role: "user", content: user_message

    response = client.chat!
    content = response.dig("choices", 0, "message", "content")
    matches = content.match(encapsuled_pattern(:game_icon_prompt))

    { game_icon_prompt: matches[1], raw: response }
  end

  def game_icon_generate(game_icon_prompt)
    client = OpenAI::Client.new(log_errors: true)
    response = client.images.generate(
      parameters: {
        prompt: game_icon_prompt,
        model: "dall-e-3",
        size: "1024x1024"
      }
    )

    image_url = response.dig("data", 0, "url")
    image_blob = Faraday.get(image_url).body
    image = "data:image/png;base64,#{Base64.strict_encode64(image_blob)}"
    { image:, raw: response }
  end

  private

  # return a regex pattern that matches the content of the tag
  # eg: encapsuled_pattern(:html_content) => /HTML-CONTENT-BEGIN\s*(?<html_content>.*?)\s*HTML-CONTENT-END/m
  def encapsuled_pattern(tag, named_capture: false)
    upper_dash_tag = tag.to_s.upcase.tr("_", "-")
    if named_capture
      Regexp.new("#{upper_dash_tag}-BEGIN\\s*(?<#{tag}>.*?)\\s*#{upper_dash_tag}-END", Regexp::MULTILINE)
    else
      Regexp.new("#{upper_dash_tag}-BEGIN\\s*(.*?)\\s*#{upper_dash_tag}-END", Regexp::MULTILINE)
    end
  end
end
