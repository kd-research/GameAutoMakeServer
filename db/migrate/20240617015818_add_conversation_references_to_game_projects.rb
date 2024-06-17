class AddConversationReferencesToGameProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :game_projects, :chat_conversation, null: false
    add_reference :game_projects, :game_generate_conversation, null: true

    add_foreign_key :game_projects, :conversations, column: :chat_conversation_id
    add_foreign_key :game_projects, :conversations, column: :game_generate_conversation_id
  end
end
