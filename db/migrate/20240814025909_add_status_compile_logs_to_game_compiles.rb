class AddStatusCompileLogsToGameCompiles < ActiveRecord::Migration[7.1]
  def change
    add_column :game_compiles, :status, :integer
    add_column :game_compiles, :compile_log, :text
  end
end
