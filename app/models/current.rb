class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :game_project, :game_compile, :game_model

  delegate :game_compile, to: :game_project, allow_nil: true

  def has_game_compile!
    game_compile = game_project.game_compile

    raise "No game compile found" unless game_compile
  end
end
