class GameProject < ApplicationRecord
  before_validation :build_chat_conversation, on: :create

  has_many :game_compiles, dependent: :destroy
  has_one :webgl_game_compile, dependent: :destroy

  belongs_to :user
  belongs_to :chat_conversation, class_name: "Conversation"
  belongs_to :game_generate_conversation, class_name: "Conversation", optional: true

  enum privacy: %w[public unlisted private].to_h { [_1, _1] }, _prefix: true
end
