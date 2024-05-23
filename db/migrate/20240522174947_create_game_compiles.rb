class CreateGameCompiles < ActiveRecord::Migration[7.1]
  def change
    create_table :game_compiles do |t|
      t.references :game_project, null: false, foreign_key: true
      t.string :platform

      t.timestamps
    end
  end
end
