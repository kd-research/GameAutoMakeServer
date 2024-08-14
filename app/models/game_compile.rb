class GameCompile < ApplicationRecord
  belongs_to :game_project
  belongs_to :gameable, polymorphic: true

  enum status: { success: 0, pending: 1, compiling: 2, failed: 3 }, _prefix: true
end
