class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :game_project

  delegate :game_compile, to: :game_project, allow_nil: true

  def has_game_compile!
    raise "No game compile found" unless game_compile
  end
end
