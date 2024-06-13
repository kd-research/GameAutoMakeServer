class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.text :system_message
      t.references :previous, null: true

      t.timestamps
    end

    add_foreign_key :conversations, :conversations, column: :previous_id, primary_key: :id
  end
end
