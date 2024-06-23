class AddCompileTypeToGameProject < ActiveRecord::Migration[7.1]
  def change
    add_column :game_projects, :compile_type, :string, default: 'unity'
  end
end
