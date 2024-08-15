class AssignUniqToGameProjectIdGameableId < ActiveRecord::Migration[7.1]
  def change 
    remove_index :game_compiles, [:gameable_id, :gameable_type] # Gameable may be nil if project is not yet compiled
    remove_index :game_compiles, :game_project_id

    change_column_null :game_compiles, :gameable_id, true
    change_column_null :game_compiles, :gameable_type, true
    add_index :game_compiles, :game_project_id, unique: true
  end
end
