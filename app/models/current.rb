class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :game_project

  delegate :game_compile, to: :game_project, allow_nil: true
end
