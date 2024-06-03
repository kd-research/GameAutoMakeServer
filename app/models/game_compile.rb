class GameCompile < ApplicationRecord
  belongs_to :game_project
  has_one_attached :package

  enum platform: %w[webGL android iOS].to_h { [_1, _1] }, _prefix: true
end
