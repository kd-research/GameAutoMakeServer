# GameCompile represents a compile process of a game project. After compiling, game_compile will hold the gameable object which is the compiled game.
class GameCompile < ApplicationRecord
  belongs_to :game_project
  belongs_to :gameable, polymorphic: true, optional: true

  enum status: { success: 0, pending: 1, compiling: 2, fail: 3, locked: 4 }, _prefix: true
  delegate :gameklass, :game_compile_data, to: :game_project

  def run_compile
    self.update!(status: :compiling)

    reason = catch(:build_abort) do
      gameable, log = gameklass.build(**game_compile_data)
      self.update!(status: :success, gameable:, compile_log: log)
      return
    end

    self.update!(status: :fail, compile_log: reason)
  rescue StandardError => e
    self.update!(status: :fail, compile_log: e.message + "\n" + e.backtrace.join("\n"))
  end
end
