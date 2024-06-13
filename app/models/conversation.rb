class Conversation < ApplicationRecord
  # previous is the parent conversation that generated this conversation
  # replies is the list of all child conversations generated from this conversation
  belongs_to :previous, class_name: "Conversation", optional: true
  has_many :replies, class_name: "Conversation", foreign_key: "previous_id", inverse_of: :previous, dependent: :nullify

  # dialog is the direct request and response generated from the conversation
  # dialogs is the list of all messages except the last one, serving as the history of the conversation
  has_many :dialogs, through: :conversation_dialogs
  has_one :dialog, dependent: :destroy
end
