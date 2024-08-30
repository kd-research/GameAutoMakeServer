class CompileJob < ApplicationJob
  retry_on Resque::PruneDeadWorkerDirtyExit, wait: 1.minutes, attempts: 3

  queue_as :compile

  def perform(game_compile_id)
    GameCompile.find(game_compile_id).run_compile
  end
end
