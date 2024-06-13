class CreateDialogs < ActiveRecord::Migration[7.1]
  def change
    create_table :dialogs do |t|
      t.string :request_role
      t.text :request_message
      t.string :response_role
      t.text :response_message
      t.references :conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
