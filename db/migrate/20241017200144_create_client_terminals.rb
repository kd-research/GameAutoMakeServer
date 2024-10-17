class CreateClientTerminals < ActiveRecord::Migration[7.2]
  def change
    create_table :client_terminals do |t|
      t.column :snowflake_id, :bigint, null: false

      t.timestamps
    end
    add_index :client_terminals, :snowflake_id
  end
end
