class CreateHtmlGameCompiles < ActiveRecord::Migration[7.1]
  def change
    create_table :html_game_compiles do |t|
      t.references :game_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
