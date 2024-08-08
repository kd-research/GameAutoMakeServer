class AddGameableIdGameableTypeToGameCompiles < ActiveRecord::Migration[7.1]
  def change
    GameCompile.delete_all

    add_column :game_compiles, :gameable_id, :integer, null: false
    add_column :game_compiles, :gameable_type, :string, null: false
    add_index :game_compiles, [:gameable_id, :gameable_type]
    remove_column :game_compiles, :platform, :string

    add_column :html_game_compiles, :model_type, :string
  end
end
