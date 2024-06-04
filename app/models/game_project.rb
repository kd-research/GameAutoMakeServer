class GameProject < ApplicationRecord
  has_many :game_compiles, dependent: :destroy
  has_one :webgl_game_compile, dependent: :destroy

  belongs_to :user

  enum privacy: %w[public unlisted private].to_h { [_1, _1] }, _prefix: true
end
