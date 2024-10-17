module ScoreBoard
  class Score < ApplicationRecord
    validates :value, presence: true

    belongs_to :client_terminal
    belongs_to :published_game

    def self.ranked_device_game_score(device, game, limit: 3)
      scores_with_rank = where(published_game: game)
        .select('score_board_scores.*, RANK() OVER (ORDER BY value DESC) rank')

      from(scores_with_rank, :score_board_scores)
        .where(client_terminal: device)
        .limit(limit)
    end
  end
end
