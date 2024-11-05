class PublishedGame < ApplicationRecord
  has_many :scores, class_name: "ScoreBoard::Score"

  def leaderboard(limit: 10)
    scores.order(value: :desc).limit(limit)
  end
end
