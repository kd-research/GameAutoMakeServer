class CreateScoreBoardScores < ActiveRecord::Migration[7.2]
  def change
    create_table :score_board_scores do |t|
      t.references :client_terminal, null: false, foreign_key: true
      t.references :published_game, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
