class GameCompile < ApplicationRecord
  belongs_to :game_project
  belongs_to :gameable, polymorphic: true
end
