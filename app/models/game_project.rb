class GameProject < ApplicationRecord
  has_many :game_compiles

  enum privacy: %w[public unlisted private].map{[_1, _1]}.to_h, _prefix: true
end
