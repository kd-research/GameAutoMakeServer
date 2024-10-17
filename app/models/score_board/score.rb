module ScoreBoard
  class Score < ApplicationRecord
    validates :value, presence: true

    belongs_to :client_terminal
    belongs_to :published_game
  end
end
