class Conversation < ApplicationRecord
  # previous is the parent conversation that generated this conversation
  # replies is the list of all child conversations generated from this conversation
  belongs_to :previous, class_name: "Conversation", optional: true
  has_many :replies, class_name: "Conversation", foreign_key: "previous_id", inverse_of: :previous, dependent: :nullify

  # dialog is the direct request and response generated from the conversation
  # dialogs is the list of all messages except the last one, serving as the history of the conversation
  has_and_belongs_to_many :dialogs # rubocop:disable Rails/HasAndBelongsToMany
  has_one :dialog, dependent: :destroy

  def send_message(message, role: nil, chat_system_message: nil)
    @role = role || "user"
    @chat_system_message = chat_system_message || default_system_message

    client = OpenAI::Client.new
    response = client.chat parameters: chat_parameters(message)

    request_role = @role
    request_message = message
    response_role = response.dig("choices", 0, "message", "role")
    response_message = response.dig("choices", 0, "message", "content")

    history_dialogs = dialogs.to_a + [dialog].compact
    Conversation.create(
      system_message: @chat_system_message,
      previous: self,
      dialogs: history_dialogs
    ).tap do |c|
      Dialog.create! \
        request_role:,
        request_message:,
        response_role:,
        response_message:,
        conversation: c
    end
  end

  def chat_parameters(message)
    chat_messages = []
    chat_messages << { role: "system", content: @chat_system_message }
    chat_messages.concat(all_messages)
    chat_messages << { role: @role, content: message }

    {
      model: "gpt-4o",
      messages: chat_messages
    }
  end

  def all_messages
    return [] if dialog.nil?

    (dialogs + [dialog]).flat_map do |d|
      [
        { role: d.request_role, content: d.request_message },
        { role: d.response_role, content: d.response_message }
      ]
    end
  end

  def default_system_message
    "You are an assistant interacting with the developer. Introduce yourself before every response."
  end
end
