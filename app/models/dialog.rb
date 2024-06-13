class Dialog < ApplicationRecord
  # conversation is the direct message from openai's last request message and response
  # conversations is the list of all messages except the last one, serving as the history of the conversation
  has_many :conversations, through: :conversation_dialogs
  belongs_to :conversation
end
