class RemoveGameProjectIdFromHtmlGameCompile < ActiveRecord::Migration[7.1]
  def change
    remove_column :html_game_compiles, :game_project_id, :integer
    remove_column :webgl_game_compiles, :game_project_id, :integer
  end
end
