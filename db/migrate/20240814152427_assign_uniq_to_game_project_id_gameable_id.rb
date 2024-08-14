class AssignUniqToGameProjectIdGameableId < ActiveRecord::Migration[7.1]
  def change 
    remove_index :game_compiles, [:gameable_id, :gameable_type]
    remove_index :game_compiles, :game_project_id

    add_index :game_compiles, [:gameable_id, :gameable_type], unique: true
    add_index :game_compiles, :game_project_id, unique: true
  end
end
