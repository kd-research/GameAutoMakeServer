class CompileJob < ApplicationJob
  queue_as :compile

  def perform(game_compile_id)
    GameCompile.find(game_compile_id).run_compile
  end
end
