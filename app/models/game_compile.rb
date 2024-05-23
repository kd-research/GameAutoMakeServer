class GameCompile < ApplicationRecord
  belongs_to :game_project
  has_one_attached :package

  enum platform: %w[webGL android iOS].map{ [_1, _1]}.to_h, _prefix: true
end
