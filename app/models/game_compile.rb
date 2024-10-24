# GameCompile represents a compile process of a game project. After compiling, game_compile will hold the gameable object which is the compiled game.
class GameCompile < ApplicationRecord
  belongs_to :game_project
  belongs_to :gameable, polymorphic: true, optional: true

  after_update_commit :broadcast_status_change, if: :saved_change_to_status?

  enum :status, { success: 0, pending: 1, compiling: 2, fail: 3, locked: 4, stale: 5 }, prefix: true
  delegate :gameklass, :game_compile_data, to: :game_project

  def run_compile
    update!(status: :compiling)

    reason = catch(:build_abort) do
      gameable, log = gameklass.build(**game_compile_data)
      update!(status: :success, gameable:, compile_log: log)
      return
    end

    update!(status: :fail, compile_log: reason)
  rescue StandardError => e
    update!(status: :fail, compile_log: "#{e.message}\n#{e.backtrace.join("\n")}")
  end

  private

  def broadcast_status_change
    reload

    Current.set(game_project:) do
      broadcast_replace_to game_project,
                           partial: "game_projects/game_project_common_controls", target: "gp-common-controls"
    end
  end
end
