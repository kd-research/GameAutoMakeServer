class CreatePublishedGames < ActiveRecord::Migration[7.2]
  def change
    create_table :published_games do |t|
      t.string :name

      t.timestamps
    end
  end
end
