class CreateJoinTableConversationDialog < ActiveRecord::Migration[7.1]
  def change
    create_join_table :conversations, :dialogs
  end
end
