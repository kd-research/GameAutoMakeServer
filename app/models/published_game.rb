class PublishedGame < ApplicationRecord
  has_many :scores, class_name: 'ScoreBoard::Score', foreign_key: :published_game_id

  def leaderboard(limit: 10)
    scores.order(value: :desc).limit(limit)
  end
end
