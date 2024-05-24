class GameProject < ApplicationRecord
  has_many :game_compiles, dependent: :destroy
  has_one :webgl_game_compile, dependent: :destroy

  enum privacy: %w[public unlisted private].map{[_1, _1]}.to_h, _prefix: true
end
