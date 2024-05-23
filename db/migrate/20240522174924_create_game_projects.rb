class CreateGameProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :game_projects do |t|
      t.string :name
      t.text :description
      t.string :privacy

      t.timestamps
    end
  end
end
