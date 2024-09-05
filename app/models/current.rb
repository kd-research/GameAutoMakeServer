class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :game_project

  delegate :game_compile, to: :game_project, allow_nil: true

  def self.has_game_compile!
    raise "No game compile found" unless game_compile
  end

  def self.user_owns_game_project?
    user && game_project && user.id == game_project.user_id
  end

  def self.user_can_manage_game_project?
    user_owns_game_project? || user&.admin?
  end
end
